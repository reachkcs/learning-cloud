# End-to-End-AI-Chatbot-with-Langraph-FastAPI-and-Streamlit-UI

## Setup

1. Install dependencies using uv:
```bash
uv sync
```

## Running the Application

This application consists of two components that need to be running simultaneously:

### 1. Start the FastAPI Backend Server

In one terminal, run:
```bash
uv run python app.py
```

The server will start on `http://127.0.0.1:8000`

### 2. Start the Streamlit UI

In another terminal, run:
```bash
uv run streamlit run ui.py
```

The UI will open in your browser, typically at `http://localhost:8501`

## Usage

1. Make sure both servers are running (backend on port 8000, UI on port 8501)
2. Open the Streamlit UI in your browser
3. Enter your system prompt (e.g., "You are an analyst")
4. Select a model (e.g., "llama3-70b-8192")
5. Enter your message and click Submit

## Note

**Important**: The FastAPI backend server must be running before you can use the Streamlit UI. If you see a connection error, make sure the backend server is started first.
