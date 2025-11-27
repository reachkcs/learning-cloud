#!/opt/anaconda3/bin/python
"""
PDF to MP3 Converter using Microsoft Azure Cognitive Services
High-quality, fast, and reliable TTS conversion.
"""

import sys
import os
import argparse
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
    import azure.cognitiveservices.speech as speechsdk
    AZURE_AVAILABLE = True
except ImportError:
    AZURE_AVAILABLE = False


class AzurePDFToMP3Converter:
    """Convert PDF to MP3 using Azure Cognitive Services."""
    
    def __init__(self, subscription_key, region, verbose=True):
        self.subscription_key = subscription_key
        self.region = region
        self.verbose = verbose
        
        # Configure speech config
        self.speech_config = speechsdk.SpeechConfig(
            subscription=subscription_key, 
            region=region
        )
        self.speech_config.speech_synthesis_voice_name = "en-US-JennyNeural"
    
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
    
    def chunk_text(self, text, max_chunk_size=4000):
        """Split text into smaller chunks for Azure TTS."""
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
    
    def convert_to_mp3(self, text, output_path):
        """Convert text to MP3 using Azure TTS."""
        if not AZURE_AVAILABLE:
            raise ImportError("Azure Speech SDK not available. Install with: pip install azure-cognitiveservices-speech")
        
        try:
            self.log("☁️  Using Azure Cognitive Services TTS...")
            
            # Split text into chunks
            chunks = self.chunk_text(text)
            self.log(f"📝 Processing {len(chunks)} chunks...")
            
            # Configure audio output
            audio_config = speechsdk.audio.AudioOutputConfig(filename=str(output_path))
            speech_synthesizer = speechsdk.SpeechSynthesizer(
                speech_config=self.speech_config, 
                audio_config=audio_config
            )
            
            # Process each chunk
            for i, chunk in enumerate(chunks, 1):
                self.log(f"🔄 Processing chunk {i}/{len(chunks)}...")
                
                # Synthesize speech
                result = speech_synthesizer.speak_text_async(chunk).get()
                
                if result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
                    self.log(f"✅ Chunk {i} completed")
                else:
                    self.log(f"⚠️  Chunk {i} failed: {result.reason}")
            
            self.log(f"✅ MP3 saved as: {output_path}")
            return True
            
        except Exception as e:
            self.log(f"❌ Azure TTS error: {str(e)}")
            return False
    
    def convert(self, pdf_path, output_path=None):
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
        
        # Convert text to speech
        self.log("🔊 Converting text to speech...")
        
        if self.convert_to_mp3(text, output_path):
            return output_path
        else:
            raise RuntimeError("Azure TTS conversion failed")


def main():
    """Main function with command line interface."""
    parser = argparse.ArgumentParser(
        description="Convert PDF files to MP3 using Azure Cognitive Services",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python pdf_to_mp3_azure.py document.pdf --key YOUR_KEY --region eastus
  python pdf_to_mp3_azure.py document.pdf -o output.mp3 --key YOUR_KEY --region eastus
        """
    )
    
    parser.add_argument("pdf_file", help="Path to the PDF file")
    parser.add_argument("-o", "--output", help="Output MP3 file path (default: same name as PDF)")
    parser.add_argument("--key", required=True, help="Azure Speech Service subscription key")
    parser.add_argument("--region", required=True, help="Azure region (e.g., eastus, westus)")
    parser.add_argument("-v", "--verbose", action="store_true", default=True, 
                       help="Enable verbose output")
    
    args = parser.parse_args()
    
    # Check if required packages are installed
    if not PDF_AVAILABLE:
        print("❌ PyPDF2 not available. Install with: pip install PyPDF2")
        return
    
    if not AZURE_AVAILABLE:
        print("❌ Azure Speech SDK not available. Install with:")
        print("   pip install azure-cognitiveservices-speech")
        return
    
    try:
        # Create converter instance
        converter = AzurePDFToMP3Converter(args.key, args.region, args.verbose)
        
        # Convert PDF to MP3
        output_path = converter.convert(args.pdf_file, args.output)
        
        print(f"🎉 Success! MP3 file created: {output_path}")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        sys.exit(1)


if __name__ == "__main__":
    main() 