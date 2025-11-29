"""Streamlit frontend for the chatbot."""
import streamlit as st
import httpx
from agent import AVAILABLE_MODELS

# Page configuration
st.set_page_config(
    page_title="Sreedhar's Chatbot",
    page_icon="🤖",
    layout="wide"
)

# Title
st.title("🤖 Sreedhar's Chatbot")
st.markdown("Ask a question and get top results from your selected LLM model")

# Initialize session state
if "chat_history" not in st.session_state:
    st.session_state.chat_history = []

# Sidebar for model selection
with st.sidebar:
    st.header("⚙️ Configuration")
    
    # Model selection
    selected_model = st.selectbox(
        "Select LLM Model",
        options=list(AVAILABLE_MODELS.keys()),
        index=0,
        help="Choose the language model to use for generating responses"
    )
    
    # Number of results
    num_results = st.slider(
        "Number of Results",
        min_value=1,
        max_value=5,
        value=2,
        help="Number of top results to display"
    )
    
    # Optional system prompt
    default_prompt = "You are a helpful AI assistant. Answer clearly and concisely."
    system_prompt = st.text_area(
        "System Prompt (optional)",
        value=default_prompt,
        help="Customize the system instructions sent to the model"
    )
    
    st.divider()
    st.markdown("### 📝 Instructions")
    st.markdown("""
    1. Enter your question in the text area
    2. Select your preferred LLM model
    3. (Optional) Update the system prompt
    4. Click 'Submit Question' to get results
    """)
    
    # API endpoint configuration
    api_url = st.text_input(
        "API URL",
        value="http://localhost:8000",
        help="FastAPI backend URL"
    )

# Main content area
question = st.text_area(
    "Enter your question:",
    height=100,
    placeholder="Type your question here...",
    help="Ask any question and the chatbot will provide multiple responses"
)

col1, col2 = st.columns([1, 5])
with col1:
    submit_button = st.button("🚀 Submit Question", type="primary", use_container_width=True)

with col2:
    clear_button = st.button("🗑️ Clear History", use_container_width=True)

if clear_button:
    st.session_state.chat_history = []
    st.rerun()

# Process question when submitted
if submit_button and question.strip():
    with st.spinner("Generating responses..."):
        try:
            # Verify API is accessible and is our API
            with httpx.Client(timeout=10.0) as client:
                try:
                    # Check root endpoint to verify it's our API
                    root_response = client.get(f"{api_url}/")
                    if root_response.status_code == 200:
                        root_data = root_response.json()
                        if "message" in root_data and "Chatbot API" in root_data.get("message", ""):
                            st.sidebar.success("✅ Connected to Chatbot API")
                        else:
                            st.sidebar.warning(f"⚠️ API at {api_url} may not be the Chatbot API")
                except Exception as e:
                    st.sidebar.error(f"❌ Cannot connect to API at {api_url}: {str(e)}")
                    st.error(f"❌ Cannot connect to API. Please ensure the FastAPI server is running at {api_url}")
                    st.stop()
            
            # Make API request
            with httpx.Client(timeout=60.0) as client:
                payload = {
                    "question": question,
                    "model": selected_model,
                    "model_name": selected_model,  # Required by API
                    "num_results": num_results,
                    "system_prompt": system_prompt,  # Required by API
                    "messages": [question],  # Required by API - array of strings
                }
                response = client.post(f"{api_url}/chat", json=payload)
                response.raise_for_status()
                data = response.json()
            
            # Check if response has the expected structure
            if "results" not in data:
                # Handle different error formats
                if "error" in data:
                    error_msg = data.get("error", "Unknown error")
                    st.error(f"❌ API Error: {error_msg}")
                    
                    # Show available models if it's a model validation error
                    if "model" in error_msg.lower() or "invalid" in error_msg.lower():
                        st.info(f"💡 Available models: {', '.join(AVAILABLE_MODELS.keys())}")
                        st.info(f"💡 Selected model: {selected_model}")
                else:
                    st.error(f"❌ Unexpected API response format: {data}")
                    st.json(data)  # Show the actual response for debugging
            else:
                # Check if request was successful
                if not data.get("success", True):
                    error_msg = data.get("error", "Unknown error")
                    st.error(f"❌ API Error: {error_msg}")
                else:
                    # Add to chat history
                    st.session_state.chat_history.append({
                        "question": question,
                        "model": selected_model,
                        "results": data["results"]
                    })
                    
                    # Display results
                    st.success("✅ Responses generated successfully!")
                    
                    # Show results in tabs or columns
                    if len(data["results"]) > 0:
                        tabs = st.tabs([f"Result {i+1}" for i in range(len(data["results"]))])
                        
                        for idx, result in enumerate(data["results"]):
                            with tabs[idx]:
                                st.markdown(f"### 🤖 Response from {result['model']}")
                                st.markdown("---")
                                st.markdown(result["result"])
                                st.caption(f"Result #{result['index']}")
            
            
        except httpx.HTTPStatusError as e:
            error_data = e.response.json() if e.response.content else {}
            st.error(f"❌ API Error: {error_data.get('detail', str(e))}")
        except httpx.RequestError as e:
            st.error(f"❌ Connection Error: Could not connect to API at {api_url}. Make sure the FastAPI server is running.")
        except Exception as e:
            st.error(f"❌ Error: {str(e)}")

elif submit_button and not question.strip():
    st.warning("⚠️ Please enter a question before submitting.")

# Display chat history
if st.session_state.chat_history:
    st.divider()
    st.header("📜 Chat History")
    
    for idx, entry in enumerate(reversed(st.session_state.chat_history[-5:])):  # Show last 5 entries
        with st.expander(f"Q: {entry['question'][:50]}... ({entry['model']})"):
            st.markdown(f"**Question:** {entry['question']}")
            st.markdown(f"**Model:** {entry['model']}")
            st.markdown("**Results:**")
            for result in entry['results']:
                st.markdown(f"**Result {result['index']}:**")
                st.markdown(result['result'])
                st.markdown("---")

