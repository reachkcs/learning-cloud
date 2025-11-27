#!/opt/anaconda3/bin/python
"""
PDF to MP3 Converter using ElevenLabs API
Ultra-high quality, fast, and reliable TTS conversion.
"""

import sys
import os
import argparse
import requests
from pathlib import Path

# Try to import required packages
try:
    from PyPDF2 import PdfReader
    PDF_AVAILABLE = True
except ImportError:
    try:
        from PyPDF2 import PdfFileReader as PdfReader
        PDF_AVAILABLE = True
    except ImportError:
        PDF_AVAILABLE = False


class ElevenLabsPDFToMP3Converter:
    """Convert PDF to MP3 using ElevenLabs API."""
    
    def __init__(self, api_key, verbose=True):
        self.api_key = api_key
        self.verbose = verbose
        self.base_url = "https://api.elevenlabs.io/v1"
        
        # Default voice ID (Rachel - high quality)
        self.voice_id = "21m00Tcm4TlvDq8ikWAM"
    
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
    
    def chunk_text(self, text, max_chunk_size=5000):
        """Split text into smaller chunks for ElevenLabs TTS."""
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
    
    def get_available_voices(self):
        """Get list of available voices."""
        try:
            url = f"{self.base_url}/voices"
            headers = {"xi-api-key": self.api_key}
            
            response = requests.get(url, headers=headers, timeout=30)
            
            if response.status_code == 200:
                voices = response.json()["voices"]
                return voices
            else:
                self.log(f"❌ Failed to get voices: {response.status_code}")
                return []
                
        except Exception as e:
            self.log(f"❌ Error getting voices: {str(e)}")
            return []
    
    def convert_to_mp3(self, text, output_path):
        """Convert text to MP3 using ElevenLabs TTS."""
        try:
            self.log("🚀 Using ElevenLabs TTS (ultra-high quality)...")
            
            # Split text into chunks
            chunks = self.chunk_text(text)
            self.log(f"📝 Processing {len(chunks)} chunks...")
            
            # Process each chunk
            audio_segments = []
            
            for i, chunk in enumerate(chunks, 1):
                self.log(f"🔄 Processing chunk {i}/{len(chunks)}...")
                
                url = f"{self.base_url}/text-to-speech/{self.voice_id}"
                headers = {
                    "Accept": "audio/mpeg",
                    "Content-Type": "application/json",
                    "xi-api-key": self.api_key
                }
                
                data = {
                    "text": chunk,
                    "model_id": "eleven_monolingual_v1",
                    "voice_settings": {
                        "stability": 0.5,
                        "similarity_boost": 0.5,
                        "style": 0.0,
                        "use_speaker_boost": True
                    }
                }
                
                response = requests.post(url, json=data, headers=headers, timeout=60)
                
                if response.status_code == 200:
                    audio_segments.append(response.content)
                    self.log(f"✅ Chunk {i} completed")
                else:
                    self.log(f"❌ Chunk {i} failed: {response.status_code}")
                    return False
            
            # Combine audio segments
            if audio_segments:
                with open(output_path, "wb") as f:
                    for segment in audio_segments:
                        f.write(segment)
                
                self.log(f"✅ MP3 saved as: {output_path}")
                return True
            else:
                return False
            
        except Exception as e:
            self.log(f"❌ ElevenLabs TTS error: {str(e)}")
            return False
    
    def convert(self, pdf_path, output_path=None, voice_id=None):
        """Convert PDF to MP3."""
        # Validate input file
        pdf_path = Path(pdf_path)
        if not pdf_path.exists():
            raise FileNotFoundError(f"PDF file not found: {pdf_path}")
        
        # Set voice ID if provided
        if voice_id:
            self.voice_id = voice_id
        
        # Set output path
        if output_path is None:
            output_path = pdf_path.with_suffix('.mp3')
        else:
            output_path = Path(output_path)
        
        # Extract text from PDF
        text = self.extract_text_from_pdf(pdf_path)
        
        # Convert text to speech
        self.log("🔊 Converting text to speech...")
        
        if self.convert_to_mp3(text, output_path):
            return output_path
        else:
            raise RuntimeError("ElevenLabs TTS conversion failed")


def main():
    """Main function with command line interface."""
    parser = argparse.ArgumentParser(
        description="Convert PDF files to MP3 using ElevenLabs API",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pdf_to_mp3_elevenlabs.py document.pdf --key YOUR_API_KEY
  python pdf_to_mp3_elevenlabs.py document.pdf -o output.mp3 --key YOUR_API_KEY
  python pdf_to_mp3_elevenlabs.py document.pdf --key YOUR_API_KEY --voice 21m00Tcm4TlvDq8ikWAM
        """
    )
    
    parser.add_argument("pdf_file", help="Path to the PDF file")
    parser.add_argument("-o", "--output", help="Output MP3 file path (default: same name as PDF)")
    parser.add_argument("--key", required=True, help="ElevenLabs API key")
    parser.add_argument("--voice", help="Voice ID (default: Rachel)")
    parser.add_argument("--list-voices", action="store_true", help="List available voices")
    parser.add_argument("-v", "--verbose", action="store_true", default=True, 
                       help="Enable verbose output")
    
    args = parser.parse_args()
    
    # Check if required packages are installed
    if not PDF_AVAILABLE:
        print("❌ PyPDF2 not available. Install with: pip install PyPDF2")
        return
    
    try:
        # Create converter instance
        converter = ElevenLabsPDFToMP3Converter(args.key, args.verbose)
        
        # List voices if requested
        if args.list_voices:
            print("Available voices:")
            voices = converter.get_available_voices()
            for voice in voices:
                print(f"  {voice['voice_id']}: {voice['name']}")
            return
        
        # Convert PDF to MP3
        output_path = converter.convert(args.pdf_file, args.output, args.voice)
        
        print(f"🎉 Success! MP3 file created: {output_path}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 