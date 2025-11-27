#!/opt/anaconda3/bin/python
"""
PDF to MP3 Converter using OpenAI Whisper + TTS
Advanced approach: Extract text, then convert to speech.
"""

import sys
import os
import argparse
import subprocess
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

try:
    import openai
    OPENAI_AVAILABLE = True
except ImportError:
    OPENAI_AVAILABLE = False

try:
    import pyttsx3
    PYTTSX3_AVAILABLE = True
except ImportError:
    PYTTSX3_AVAILABLE = False


class WhisperPDFToMP3Converter:
    """Convert PDF to MP3 using Whisper + TTS."""
    
    def __init__(self, openai_key=None, verbose=True):
        self.openai_key = openai_key
        self.verbose = verbose
        
        if openai_key and OPENAI_AVAILABLE:
            openai.api_key = openai_key
    
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
    
    def enhance_text_with_whisper(self, text):
        """Enhance text using OpenAI Whisper for better pronunciation."""
        if not self.openai_key or not OPENAI_AVAILABLE:
            self.log("⚠️  OpenAI not available, using original text")
            return text
        
        try:
            self.log("🤖 Enhancing text with OpenAI Whisper...")
            
            # Use OpenAI to improve text for TTS
            response = openai.ChatCompletion.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a text enhancement expert. Improve the given text for better text-to-speech pronunciation. Fix any typos, add proper punctuation, and make it more natural for reading aloud. Keep the original meaning intact."},
                    {"role": "user", "content": text}
                ],
                max_tokens=2000,
                temperature=0.3
            )
            
            enhanced_text = response.choices[0].message.content
            self.log("✅ Text enhanced with Whisper")
            return enhanced_text
            
        except Exception as e:
            self.log(f"⚠️  Whisper enhancement failed: {str(e)}")
            return text
    
    def convert_to_mp3_offline(self, text, output_path):
        """Convert text to MP3 using offline TTS."""
        if not PYTTSX3_AVAILABLE:
            raise ImportError("pyttsx3 not available. Install with: pip install pyttsx3")
        
        try:
            self.log("🔊 Using offline TTS...")
            
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
    
    def convert_to_mp3_whisper(self, text, output_path):
        """Convert text to MP3 using Whisper TTS (if available)."""
        try:
            self.log("🎤 Using Whisper TTS...")
            
            # This would require OpenAI's TTS API
            # For now, we'll use offline TTS as fallback
            self.log("⚠️  Whisper TTS not implemented, using offline TTS")
            return self.convert_to_mp3_offline(text, output_path)
            
        except Exception as e:
            self.log(f"❌ Whisper TTS error: {str(e)}")
            return False
    
    def convert(self, pdf_path, output_path=None, enhance=True):
        """Convert PDF to MP3."""
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
        
        # Enhance text if requested
        if enhance and self.openai_key:
            text = self.enhance_text_with_whisper(text)
        
        # Convert text to speech
        self.log("🔊 Converting text to speech...")
        
        if self.convert_to_mp3_offline(text, output_path):
            return output_path
        else:
            raise RuntimeError("TTS conversion failed")


def main():
    """Main function with command line interface."""
    parser = argparse.ArgumentParser(
        description="Convert PDF files to MP3 using Whisper + TTS",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pdf_to_mp3_whisper.py document.pdf
  python pdf_to_mp3_whisper.py document.pdf --key YOUR_OPENAI_KEY
  python pdf_to_mp3_whisper.py document.pdf -o output.mp3 --no-enhance
        """
    )
    
    parser.add_argument("pdf_file", help="Path to the PDF file")
    parser.add_argument("-o", "--output", help="Output MP3 file path (default: same name as PDF)")
    parser.add_argument("--key", help="OpenAI API key for text enhancement")
    parser.add_argument("--no-enhance", action="store_true", help="Skip text enhancement")
    parser.add_argument("-v", "--verbose", action="store_true", default=True, 
                       help="Enable verbose output")
    
    args = parser.parse_args()
    
    # Check if required packages are installed
    if not PDF_AVAILABLE:
        print("❌ PyPDF2 not available. Install with: pip install PyPDF2")
        return
    
    if not PYTTSX3_AVAILABLE:
        print("❌ pyttsx3 not available. Install with: pip install pyttsx3")
        return
    
    try:
        # Get API key from environment if not provided
        api_key = args.key or os.getenv("OPENAI_API_KEY")
        
        # Create converter instance
        converter = WhisperPDFToMP3Converter(api_key, args.verbose)
        
        # Convert PDF to MP3
        output_path = converter.convert(
            args.pdf_file, 
            args.output, 
            enhance=not args.no_enhance
        )
        
        print(f"🎉 Success! MP3 file created: {output_path}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 