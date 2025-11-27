#!/opt/anaconda3/bin/python
"""
PDF to MP3 Converter
A fast and efficient tool to convert PDF files to MP3 audio files.
Supports multiple TTS engines with automatic fallback.
"""

import sys
import os
import time
import argparse
import signal
from pathlib import Path

# Try to import required packages
try:
    # Try new import path first (PyPDF2 >= 3.0)
    from PyPDF2 import PdfReader
    PDF_AVAILABLE = True
except ImportError:
    try:
        # Try old import path (PyPDF2 < 3.0)
        from PyPDF2 import PdfFileReader as PdfReader
        PDF_AVAILABLE = True
    except ImportError:
        PDF_AVAILABLE = False

try:
    from gtts import gTTS
    GTTS_AVAILABLE = True
except ImportError:
    GTTS_AVAILABLE = False

try:
    import pyttsx3
    PYTTSX3_AVAILABLE = True
except ImportError:
    PYTTSX3_AVAILABLE = False

try:
    import requests
    REQUESTS_AVAILABLE = True
except ImportError:
    REQUESTS_AVAILABLE = False

try:
    from pydub import AudioSegment
    PYDUB_AVAILABLE = True
except ImportError:
    PYDUB_AVAILABLE = False


class TimeoutError(Exception):
    """Custom timeout exception."""
    pass


def timeout_handler(signum, frame):
    """Handle timeout signal."""
    raise TimeoutError("Operation timed out")


class PDFToMP3Converter:
    """Main converter class with multiple TTS engines."""
    
    def __init__(self, verbose=True, timeout=300):  # 5 minute timeout
        self.verbose = verbose
        self.timeout = timeout
        self.supported_engines = self._detect_engines()
    
    def _detect_engines(self):
        """Detect available TTS engines."""
        engines = {}
        
        if GTTS_AVAILABLE:
            engines['gtts'] = "Google Text-to-Speech (free, online)"
        
        if PYTTSX3_AVAILABLE:
            engines['offline'] = "Offline TTS (no internet required)"
        
        if REQUESTS_AVAILABLE:
            engines['elevenlabs'] = "ElevenLabs (high quality, requires API key)"
        
        return engines
    
    def log(self, message):
        """Print log message if verbose mode is enabled."""
        if self.verbose:
            print(message)
    
    def extract_text_from_pdf(self, pdf_path):
        """Extract text from PDF file."""
        if not PDF_AVAILABLE:
            raise ImportError("PyPDF2 not available. Install with: pip install PyPDF2")
        
        self.log(f"📖 Reading PDF: {pdf_path}")
        
        reader = PdfReader(pdf_path)
        text = ""
        total_pages = len(reader.pages)
        
        for i, page in enumerate(reader.pages, 1):
            self.log(f"📄 Processing page {i}/{total_pages}")
            page_text = page.extract_text()
            if page_text:
                text += page_text + "\n"
        
        if not text.strip():
            raise ValueError("No text found in the PDF file")
        
        self.log(f"📝 Extracted {len(text)} characters of text")
        return text.strip()
    
    def chunk_text(self, text, max_chunk_size=3000):
        """Split text into smaller chunks for better TTS processing."""
        words = text.split()
        chunks = []
        current_chunk = ""
        
        for word in words:
            if len(current_chunk + " " + word) <= max_chunk_size:
                current_chunk += " " + word if current_chunk else word
            else:
                if current_chunk:
                    chunks.append(current_chunk)
                current_chunk = word
        
        if current_chunk:
            chunks.append(current_chunk)
        
        return chunks
    
    def convert_with_gtts(self, text, output_path):
        """Convert text to speech using Google TTS with timeout."""
        if not GTTS_AVAILABLE:
            return False
        
        try:
            self.log("🌐 Using Google TTS...")
            self.log("⚠️  This may take a while and could hang due to rate limiting.")
            self.log("💡 Consider using --engine offline for faster, more reliable results.")
            
            # Split text into chunks for better processing
            chunks = self.chunk_text(text)
            self.log(f"📝 Processing {len(chunks)} chunks...")
            
            audio_segments = []
            
            # Set timeout for the entire operation
            signal.signal(signal.SIGALRM, timeout_handler)
            signal.alarm(self.timeout)
            
            try:
                for i, chunk in enumerate(chunks, 1):
                    self.log(f"🔄 Processing chunk {i}/{len(chunks)}...")
                    
                    # Retry logic for rate limiting
                    for attempt in range(2):  # Reduced retries
                        try:
                            tts = gTTS(text=chunk, lang='en', slow=False)
                            
                            # Save chunk temporarily
                            temp_file = f"temp_chunk_{i}.mp3"
                            tts.save(temp_file)
                            
                            # Load with pydub if available
                            if PYDUB_AVAILABLE:
                                audio = AudioSegment.from_mp3(temp_file)
                                audio_segments.append(audio)
                            else:
                                # Simple concatenation without pydub
                                with open(temp_file, 'rb') as f:
                                    audio_segments.append(f.read())
                            
                            os.remove(temp_file)
                            break
                            
                        except Exception as e:
                            if "429" in str(e) and attempt < 1:
                                self.log(f"⚠️  Rate limited, retrying chunk {i}...")
                                time.sleep(10)  # Longer delay
                            else:
                                raise e
                
                # Combine audio segments
                if PYDUB_AVAILABLE and audio_segments:
                    combined = audio_segments[0]
                    for segment in audio_segments[1:]:
                        combined += segment
                    combined.export(output_path, format="mp3")
                else:
                    # Simple file concatenation
                    with open(output_path, 'wb') as outfile:
                        for segment in audio_segments:
                            outfile.write(segment)
                
                self.log(f"✅ MP3 saved as: {output_path}")
                return True
                
            finally:
                signal.alarm(0)  # Cancel timeout
                
        except TimeoutError:
            self.log("❌ Operation timed out. Google TTS is taking too long.")
            self.log("💡 Try using --engine offline for faster results.")
            return False
        except Exception as e:
            self.log(f"❌ Google TTS error: {str(e)}")
            return False
    
    def convert_with_offline_tts(self, text, output_path):
        """Convert text to speech using offline TTS."""
        if not PYTTSX3_AVAILABLE:
            return False
        
        try:
            self.log("🔊 Using offline TTS (fast and reliable)...")
            
            engine = pyttsx3.init()
            
            # Configure voice settings
            voices = engine.getProperty('voices')
            if voices:
                engine.setProperty('voice', voices[0].id)
            
            # Set speech rate and volume
            engine.setProperty('rate', 150)
            engine.setProperty('volume', 0.9)
            
            # Save to file
            engine.save_to_file(text, output_path)
            engine.runAndWait()
            
            self.log(f"✅ MP3 saved as: {output_path}")
            return True
            
        except Exception as e:
            self.log(f"❌ Offline TTS error: {str(e)}")
            return False
    
    def convert_with_elevenlabs(self, text, output_path, api_key):
        """Convert text to speech using ElevenLabs API."""
        if not REQUESTS_AVAILABLE or not api_key:
            return False
        
        try:
            self.log("🚀 Using ElevenLabs TTS (high quality)...")
            
            url = "https://api.elevenlabs.io/v1/text-to-speech/21m00Tcm4TlvDq8ikWAM"
            headers = {
                "Accept": "audio/mpeg",
                "Content-Type": "application/json",
                "xi-api-key": api_key
            }
            
            data = {
                "text": text,
                "model_id": "eleven_monolingual_v1",
                "voice_settings": {
                    "stability": 0.5,
                    "similarity_boost": 0.5
                }
            }
            
            response = requests.post(url, json=data, headers=headers, timeout=60)
            
            if response.status_code == 200:
                with open(output_path, "wb") as f:
                    f.write(response.content)
                self.log(f"✅ MP3 saved as: {output_path}")
                return True
            else:
                self.log(f"❌ ElevenLabs API error: {response.status_code}")
                return False
                
        except Exception as e:
            self.log(f"❌ ElevenLabs error: {str(e)}")
            return False
    
    def convert(self, pdf_path, output_path=None, engine="auto", api_key=None):
        """
        Convert PDF to MP3 using the specified engine.
        
        Args:
            pdf_path (str): Path to the PDF file
            output_path (str): Path for the output MP3 file
            engine (str): TTS engine to use ("auto", "gtts", "offline", "elevenlabs")
            api_key (str): API key for cloud TTS services
        """
        # Validate input file
        pdf_path = Path(pdf_path)
        if not pdf_path.exists():
            raise FileNotFoundError(f"PDF file not found: {pdf_path}")
        
        # Set output path
        if output_path is None:
            output_path = pdf_path.with_suffix('.mp3')
        else:
            output_path = Path(output_path)
        
        # Extract text from PDF
        text = self.extract_text_from_pdf(pdf_path)
        
        # Convert text to speech
        self.log("🔊 Converting text to speech...")
        
        # Try specified engine or auto-detect (prefer offline for reliability)
        if engine == "elevenlabs" or (engine == "auto" and api_key):
            if self.convert_with_elevenlabs(text, output_path, api_key):
                return output_path
        
        elif engine == "offline" or (engine == "auto" and "offline" in self.supported_engines):
            if self.convert_with_offline_tts(text, output_path):
                return output_path
        
        elif engine == "gtts" or (engine == "auto" and "gtts" in self.supported_engines):
            if self.convert_with_gtts(text, output_path):
                return output_path
        
        # If all engines fail
        raise RuntimeError("All TTS engines failed. Check your internet connection and try again.")


def main():
    """Main function with command line interface."""
    parser = argparse.ArgumentParser(
        description="Convert PDF files to MP3 audio files",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pdf_to_mp3.py document.pdf
  python pdf_to_mp3.py document.pdf -o output.mp3
  python pdf_to_mp3.py document.pdf --engine offline  # Recommended for speed
  python pdf_to_mp3.py document.pdf --engine gtts
        """
    )
    
    parser.add_argument("pdf_file", nargs="?", help="Path to the PDF file")
    parser.add_argument("-o", "--output", help="Output MP3 file path (default: same name as PDF)")
    parser.add_argument("-e", "--engine", choices=["auto", "gtts", "offline", "elevenlabs"], 
                       default="offline", help="TTS engine to use (default: offline for speed)")
    parser.add_argument("--api-key", help="API key for cloud TTS services")
    parser.add_argument("-v", "--verbose", action="store_true", default=True, 
                       help="Enable verbose output")
    parser.add_argument("--list-engines", action="store_true", 
                       help="List available TTS engines")
    parser.add_argument("--timeout", type=int, default=300, 
                       help="Timeout in seconds for online TTS (default: 300)")
    
    args = parser.parse_args()
    
    # Create converter instance
    converter = PDFToMP3Converter(verbose=args.verbose, timeout=args.timeout)
    
    # List available engines if requested
    if args.list_engines:
        print("Available TTS engines:")
        for engine, description in converter.supported_engines.items():
            print(f"  {engine}: {description}")
        print("\n💡 Recommendation: Use 'offline' engine for fastest, most reliable results.")
        return
    
    # Check if required packages are installed
    if not PDF_AVAILABLE:
        print("❌ PyPDF2 not available. Install with: pip install PyPDF2")
        return
    
    if not any([GTTS_AVAILABLE, PYTTSX3_AVAILABLE]):
        print("❌ No TTS engines available. Install with:")
        print("   pip install gTTS pyttsx3")
        return
    
    # If no PDF file provided and not listing engines, show help
    if not args.pdf_file and not args.list_engines:
        parser.print_help()
        return
    
    try:
        # Get API key from environment if not provided
        api_key = args.api_key or os.getenv("ELEVENLABS_API_KEY")
        
        # Convert PDF to MP3
        output_path = converter.convert(
            args.pdf_file, 
            args.output, 
            args.engine, 
            api_key
        )
        
        print(f"🎉 Success! MP3 file created: {output_path}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 