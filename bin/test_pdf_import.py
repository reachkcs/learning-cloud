#!/usr/bin/env python3
"""
Test script to check PyPDF2 import and functionality.
"""

import sys
print(f"Python version: {sys.version}")
print(f"Python path: {sys.executable}")

# Test PyPDF2 import
try:
    from PyPDF2 import PdfReader
    print("✅ PyPDF2 import successful (new API)")
    print(f"PdfReader type: {type(PdfReader)}")
except ImportError as e:
    print(f"❌ PyPDF2 import failed (new API): {e}")
    try:
        from PyPDF2 import PdfFileReader as PdfReader
        print("✅ PyPDF2 import successful (old API)")
        print(f"PdfReader type: {type(PdfReader)}")
    except ImportError as e2:
        print(f"❌ PyPDF2 import failed (old API): {e2}")

# Test other imports
try:
    from gtts import gTTS
    print("✅ gTTS import successful")
except ImportError as e:
    print(f"❌ gTTS import failed: {e}")

try:
    import pyttsx3
    print("✅ pyttsx3 import successful")
except ImportError as e:
    print(f"❌ pyttsx3 import failed: {e}")

try:
    import requests
    print("✅ requests import successful")
except ImportError as e:
    print(f"❌ requests import failed: {e}")

try:
    from pydub import AudioSegment
    print("✅ pydub import successful")
except ImportError as e:
    print(f"❌ pydub import failed: {e}") 