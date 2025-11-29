"""FastAPI backend for the chatbot."""
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from models import ChatRequest, ChatResponse, ChatResult
from agent import get_multiple_responses, AVAILABLE_MODELS
import uvicorn

app = FastAPI(title="Sreedhar's Chatbot API", version="1.0.0")

# Enable CORS for Streamlit frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "Sreedhar's Chatbot API",
        "available_models": list(AVAILABLE_MODELS.keys())
    }


@app.get("/models")
async def get_models():
    """Get list of available models."""
    return {"models": list(AVAILABLE_MODELS.keys())}


@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """Chat endpoint that returns top N results from the LLM."""
    try:
        # Use model_name if provided, otherwise fall back to model
        model_to_use = request.model_name if request.model_name else request.model
        
        # Validate model - check both exact match and case-insensitive
        available_models_lower = [m.lower() for m in AVAILABLE_MODELS.keys()]
        if model_to_use.lower() not in available_models_lower:
            # Find the correct case from available models
            matching_model = None
            for model in AVAILABLE_MODELS.keys():
                if model.lower() == model_to_use.lower():
                    matching_model = model
                    break
            
            if matching_model:
                model_to_use = matching_model
            else:
                raise HTTPException(
                    status_code=400,
                    detail=f"Model '{model_to_use}' not available. Available models: {list(AVAILABLE_MODELS.keys())}"
                )
        
        # Get multiple responses
        responses = get_multiple_responses(
            question=request.question,
            model_name=model_to_use,
            num_results=request.num_results
        )
        
        # Format results
        results = [
            ChatResult(
                result=response,
                model=model_to_use,
                index=i + 1
            )
            for i, response in enumerate(responses)
        ]
        
        return ChatResponse(
            question=request.question,
            results=results,
            success=True
        )
    
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        return ChatResponse(
            question=request.question,
            results=[],
            success=False,
            error=str(e)
        )


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

