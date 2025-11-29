"""LangChain agent setup with multi-LLM support."""
import os
from typing import List, Optional
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_anthropic import ChatAnthropic
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_ollama import ChatOllama
from langchain_core.messages import HumanMessage

# Load environment variables
load_dotenv()


# Available LLM models
AVAILABLE_MODELS = {
    # OpenAI models (more current versions)
    "gpt-4o": "openai",
    "gpt-4o-mini": "openai",
    "gpt-4-turbo": "openai",
    "gpt-3.5-turbo": "openai",
    
    # Anthropic models (updated to Claude 3.5)
    "claude-3-5-sonnet": "anthropic",
    "claude-3-5-haiku": "anthropic",
    "claude-3-opus": "anthropic",
    "claude-3-sonnet": "anthropic",
    "claude-3-haiku": "anthropic",
    
    # Google models (more reliable versions)
    "gemini-1.5-flash": "google",
    "gemini-1.5-pro": "google",
    "gemini-2.0-flash-exp": "google",

    # Ollama models (local, no API key needed)
    "llama3": "ollama",
    "llama3.1": "ollama",
    "mistral": "ollama",
    "mixtral": "ollama",
    "phi3": "ollama",
    "gemma": "ollama",
}

def get_llm(model_name: str):
    """Get an LLM instance based on the model name."""
    provider = AVAILABLE_MODELS.get(model_name.lower())
    
    if provider == "openai":
        api_key = os.getenv("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("OPENAI_API_KEY environment variable not set")
        return ChatOpenAI(model=model_name, temperature=0.7, api_key=api_key)
    
    elif provider == "anthropic":
        api_key = os.getenv("ANTHROPIC_API_KEY")
        if not api_key:
            raise ValueError("ANTHROPIC_API_KEY environment variable not set")
        # Map model names to Anthropic format
        anthropic_model_map = {
            "claude-3-5-sonnet": "claude-3-5-sonnet-20241022",
            "claude-3-5-haiku": "claude-3-5-haiku-20241022",
            "claude-3-opus": "claude-3-opus-20240229",
            "claude-3-sonnet": "claude-3-sonnet-20240229",
            "claude-3-haiku": "claude-3-haiku-20240307",
        }
        model = anthropic_model_map.get(model_name.lower(), model_name.lower())
        return ChatAnthropic(model=model, temperature=0.7, api_key=api_key)

    elif provider == "google":
        api_key = os.getenv("GOOGLE_API_KEY")
        if not api_key:
            raise ValueError("GOOGLE_API_KEY environment variable not set")
        return ChatGoogleGenerativeAI(model=model_name.lower(), temperature=0.7, google_api_key=api_key)
    
    elif provider == "ollama":
        return ChatOllama(model=model_name.lower(), temperature=0.7)
    
    else:
        raise ValueError(f"Unsupported model: {model_name}")


def get_multiple_responses(question: str, model_name: str, num_results: int = 2) -> List[str]:
    """
    Get multiple responses from the LLM for the same question.
    This simulates getting 'top results' by running the query multiple times.
    """
    try:
        llm = get_llm(model_name)
        results = []
        
        # Generate multiple responses by invoking the LLM multiple times
        # In a real scenario, you might use different parameters or sampling strategies
        for i in range(num_results):
            response = llm.invoke([HumanMessage(content=question)])
            results.append(response.content)
        
        return results
    except Exception as e:
        raise Exception(f"Error getting responses from {model_name}: {str(e)}")

