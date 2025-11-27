#!/opt/anaconda3/bin/python

import sys
import os
import time
import random
import requests
from PyPDF2 import PdfReader

# Try to import various TTS options
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
    from pydub import AudioSegment
    PYDUB_AVAILABLE = True
except ImportError:
    PYDUB_AVAILABLE = False

def chunk_text(text, max_chunk_size=5000):
    """
    Split text into smaller chunks for better TTS processing.
    
    Args:
        text (str): Text to chunk
        max_chunk_size (int): Maximum characters per chunk
    
    Returns:
        list: List of text chunks
    """
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

def convert_with_elevenlabs(text, mp3_file_path, api_key=None):
    """
    Convert text to speech using ElevenLabs API (high quality, fast).
    
    Args:
        text (str): Text to convert
        mp3_file_path (str): Output MP3 file path
        api_key (str): ElevenLabs API key
    """
    if not api_key:
        print("⚠️  ElevenLabs API key not provided. Skipping...")
        return False
    
    try:
        print("🚀 Using ElevenLabs TTS (high quality)...")
        
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
        
        response = requests.post(url, json=data, headers=headers)
        
        if response.status_code == 200:
            with open(mp3_file_path, "wb") as f:
                f.write(response.content)
            print(f"✅ MP3 saved as: {mp3_file_path}")
            return True
        else:
            print(f"❌ ElevenLabs API error: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"❌ ElevenLabs error: {str(e)}")
        return False

def convert_with_azure_tts(text, mp3_file_path, api_key=None, region=None):
    """
    Convert text to speech using Azure Cognitive Services (fast, reliable).
    
    Args:
        text (str): Text to convert
        mp3_file_path (str): Output MP3 file path
        api_key (str): Azure API key
        region (str): Azure region
    """
    if not api_key or not region:
        print("⚠️  Azure credentials not provided. Skipping...")
        return False
    
    try:
        print("☁️  Using Azure TTS...")
        
        # This would require azure-cognitiveservices-speech package
        # For now, showing the approach
        print("💡 Azure TTS requires: pip install azure-cognitiveservices-speech")
        return False
        
    except Exception as e:
        print(f"❌ Azure TTS error: {str(e)}")
        return False

def convert_with_offline_tts(text, mp3_file_path):
    """
    Convert text to speech using offline TTS (pyttsx3).
    
    Args:
        text (str): Text to convert
        mp3_file_path (str): Output MP3 file path
    """
    if not PYTTSX3_AVAILABLE:
        print("❌ No offline TTS available. Please install pyttsx3:")
        print("   pip install pyttsx3")
        return False
    
    try:
        print("🔊 Using offline TTS (pyttsx3)...")
        engine = pyttsx3.init()
        
        # Configure voice settings
        voices = engine.getProperty('voices')
        if voices:
            engine.setProperty('voice', voices[0].id)
        
        # Set speech rate and volume
        engine.setProperty('rate', 150)
        engine.setProperty('volume', 0.9)
        
        # Save to file
        engine.save_to_file(text, mp3_file_path)
        engine.runAndWait()
        
        print(f"✅ MP3 saved as: {mp3_file_path}")
        return True
        
    except Exception as e:
        print(f"❌ Offline TTS error: {str(e)}")
        return False

def convert_with_gtts_chunked(text, mp3_file_path, max_retries=2):
    """
    Convert text to speech using gTTS with chunking for better performance.
    
    Args:
        text (str): Text to convert
        mp3_file_path (str): Output MP3 file path
        max_retries (int): Maximum number of retry attempts
    """
    if not GTTS_AVAILABLE:
        return False
    
    try:
        print("🌐 Using gTTS with chunking...")
        
        # Split text into chunks
        chunks = chunk_text(text, max_chunk_size=3000)
        print(f"📝 Processing {len(chunks)} chunks...")
        
        audio_segments = []
        
        for i, chunk in enumerate(chunks):
            print(f"🔄 Processing chunk {i+1}/{len(chunks)}...")
            
            for attempt in range(max_retries):
                try:
                    tts = gTTS(text=chunk, lang='en', slow=False)
                    
                    # Save chunk temporarily
                    temp_file = f"temp_chunk_{i}.mp3"
                    tts.save(temp_file)
                    
                    # Load with pydub if available
                    if PYDUB_AVAILABLE:
                        from pydub import AudioSegment
                        audio = AudioSegment.from_mp3(temp_file)
                        audio_segments.append(audio)
                    else:
                        # Simple concatenation without pydub
                        with open(temp_file, 'rb') as f:
                            audio_segments.append(f.read())
                    
                    os.remove(temp_file)
                    break
                    
                except Exception as e:
                    if attempt < max_retries - 1:
                        print(f"⚠️  Chunk {i+1} failed, retrying...")
                        time.sleep(2)
                    else:
                        print(f"❌ Failed to process chunk {i+1}")
                        return False
        
        # Combine audio segments
        if PYDUB_AVAILABLE and audio_segments:
            combined = audio_segments[0]
            for segment in audio_segments[1:]:
                combined += segment
            combined.export(mp3_file_path, format="mp3")
        else:
            # Simple file concatenation
            with open(mp3_file_path, 'wb') as outfile:
                for segment in audio_segments:
                    outfile.write(segment)
        
        print(f"✅ MP3 saved as: {mp3_file_path}")
        return True
        
    except Exception as e:
        print(f"❌ gTTS chunked error: {str(e)}")
        return False

def convert_pdf_to_mp3(pdf_file_path, tts_method="auto", api_key=None, region=None):
    """
    Convert a PDF file to MP3 audio file with multiple TTS options.
    
    Args:
        pdf_file_path (str): Path to the PDF file
        tts_method (str): TTS method to use ("auto", "elevenlabs", "azure", "gtts", "offline")
        api_key (str): API key for cloud TTS services
        region (str): Region for Azure TTS
    """
    # Check if file exists
    if not os.path.exists(pdf_file_path):
        print(f"❌ Error: File '{pdf_file_path}' not found.")
        return
    
    # Get the base name without extension for the MP3 file
    base_name = os.path.splitext(pdf_file_path)[0]
    mp3_file_path = f"{base_name}.mp3"
    
    try:
        # Step 1: Extract text from PDF
        print(f"📖 Reading PDF: {pdf_file_path}")
        reader = PdfReader(pdf_file_path)
        text = ""
        for page in reader.pages:
            text += page.extract_text()
        
        if not text.strip():
            print("❌ Error: No text found in the PDF file.")
            return
        
        print(f"📝 Extracted {len(text)} characters of text")
        
        # Step 2: Convert text to speech with selected method
        print("🔊 Converting text to speech...")
        
        if tts_method == "elevenlabs" or (tts_method == "auto" and api_key):
            if convert_with_elevenlabs(text, mp3_file_path, api_key):
                return
        
        elif tts_method == "azure" or (tts_method == "auto" and api_key and region):
            if convert_with_azure_tts(text, mp3_file_path, api_key, region):
                return
        
        elif tts_method == "gtts" or tts_method == "auto":
            if convert_with_gtts_chunked(text, mp3_file_path):
                return
        
        # Fallback to offline TTS
        if convert_with_offline_tts(text, mp3_file_path):
            return
        
        # If all fail, provide installation instructions
        print("❌ All TTS methods failed.")
        print("💡 To fix this, install one of these packages:")
        print("   pip install pyttsx3 pydub gTTS")
        print("   # For premium TTS: pip install azure-cognitiveservices-speech")
        
    except Exception as e:
        print(f"❌ Error: {str(e)}")

def show_usage_help():
    """Show detailed usage information and troubleshooting tips."""
    print("Usage: python convert_pdf_to_mp3.py <pdf_file_path> [tts_method]")
    print("Example: python convert_pdf_to_mp3.py document.pdf")
    print("Example: python convert_pdf_to_mp3.py document.pdf gtts")
    print("\nTTS Methods (in order of preference):")
    print("- elevenlabs: High quality, fast (requires API key)")
    print("- azure: Microsoft Azure TTS (requires API key)")
    print("- gtts: Google TTS (free, may have rate limits)")
    print("- offline: Local TTS (no internet required)")
    print("\nInstallation:")
    print("  pip install gTTS pyttsx3 pydub PyPDF2")
    print("  # For premium TTS: pip install azure-cognitiveservices-speech")
    print("\nEnvironment Variables:")
    print("  ELEVENLABS_API_KEY=your_key")
    print("  AZURE_SPEECH_KEY=your_key")
    print("  AZURE_SPEECH_REGION=your_region")

def main():
    """Main function to handle command line arguments."""
    if len(sys.argv) < 2:
        show_usage_help()
        sys.exit(1)
    
    pdf_file_path = sys.argv[1]
    tts_method = sys.argv[2] if len(sys.argv) > 2 else "auto"
    
    # Get API keys from environment
    elevenlabs_key = os.getenv("ELEVENLABS_API_KEY")
    azure_key = os.getenv("AZURE_SPEECH_KEY")
    azure_region = os.getenv("AZURE_SPEECH_REGION")
    
    convert_pdf_to_mp3(pdf_file_path, tts_method, elevenlabs_key, azure_region)

if __name__ == "__main__":
    main()

