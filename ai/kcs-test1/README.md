# AI Chatbot with LangChain, Streamlit, FastAPI, and Pydantic

A multi-component chatbot application that allows users to submit questions, select LLM models, and view top results from the language model.

## Features

- 🤖 **LangChain Agent**: Powered by LangChain for LLM interactions
- 🎨 **Streamlit Frontend**: Beautiful and intuitive web interface
- 🚀 **FastAPI Backend**: High-performance REST API
- ✅ **Pydantic Validation**: Type-safe request/response models
- 🔄 **Multi-LLM Support**: Support for OpenAI and Anthropic models
- 📊 **Top Results**: Display multiple responses for each question

## Supported Models

- **OpenAI**: GPT-4, GPT-3.5-turbo
- **Anthropic**: Claude-3-Opus, Claude-3-Sonnet, Claude-3-Haiku

## Installation

1. **Clone the repository** (if applicable) or navigate to the project directory

2. **Install dependencies** (choose one method):

   **Using uv (recommended):**
   ```bash
   # First install pyarrow with pre-built wheel to avoid build issues
   uv pip install pyarrow --only-binary :all:
   # Then install the rest
   uv pip install -e .
   ```
   
   **Or using pip:**
   ```bash
   # First install pyarrow with pre-built wheel to avoid build issues
   pip install pyarrow --only-binary :all:
   # Then install the rest
   pip install -e .
   ```
   
   **Note:** If you encounter build errors with `pyarrow`, install it separately first using `--only-binary :all:` to use pre-built wheels instead of building from source.

3. **Set up environment variables**:
   - Copy `.env.example` to `.env`
   - Add your API keys:
     ```
     OPENAI_API_KEY=your_openai_api_key_here
     ANTHROPIC_API_KEY=your_anthropic_api_key_here
     ```

## Usage

### Running the Application

**Using uv:**

After installing dependencies, you can run the applications directly:

1. **Start the FastAPI backend** (in one terminal):
   ```bash
   python api.py
   ```
   The API will be available at `http://localhost:8000`

2. **Start the Streamlit frontend** (in another terminal):
   ```bash
   streamlit run streamlit_app.py
   ```
   The UI will open in your browser at `http://localhost:8501`

**Note:** If you prefer to use `uv run`, you may encounter issues with `pyarrow` trying to build from source. The recommended approach is to install dependencies once with `uv pip install` and then run the applications directly with `python` and `streamlit`.

**Or using standard Python:**

1. **Start the FastAPI backend** (in one terminal):
   ```bash
   python api.py
   ```
   The API will be available at `http://localhost:8000`

2. **Start the Streamlit frontend** (in another terminal):
   ```bash
   streamlit run streamlit_app.py
   ```
   The UI will open in your browser at `http://localhost:8501`

### Using the Chatbot

1. Open the Streamlit app in your browser
2. Enter your question in the text area
3. Select your preferred LLM model from the sidebar
4. Choose the number of results to display (default: 2)
5. Click "Submit Question"
6. View the top results in the tabs below

### API Endpoints

- `GET /`: Root endpoint with API information
- `GET /models`: Get list of available models
- `POST /chat`: Submit a question and get results
  ```json
  {
    "question": "What is artificial intelligence?",
    "model": "gpt-4",
    "num_results": 2
  }
  ```

## Project Structure

```
kcs-test1/
├── api.py              # FastAPI backend
├── streamlit_app.py    # Streamlit frontend
├── agent.py            # LangChain agent setup
├── models.py           # Pydantic models
├── main.py             # Main entry point
├── pyproject.toml      # Project dependencies
├── .env.example        # Environment variables template
└── README.md           # This file
```

## Requirements

- Python >= 3.12
- OpenAI API key (for GPT models)
- Anthropic API key (for Claude models)

## Notes

- Make sure both the FastAPI server and Streamlit app are running simultaneously
- The default API URL in Streamlit is `http://localhost:8000` - adjust if needed
- API keys are required for the LLM providers you want to use

