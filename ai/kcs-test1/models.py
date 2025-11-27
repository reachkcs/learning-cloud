"""Pydantic models for request/response validation."""
from pydantic import BaseModel, Field
from typing import List, Optional


class ChatRequest(BaseModel):
    """Request model for chat endpoint."""
    question: str = Field(..., description="The question to ask the chatbot")
    model: str = Field(..., description="The LLM model to use")
    num_results: int = Field(default=2, ge=1, le=10, description="Number of results to return")
    model_name: str = Field(..., description="Model name (required by API)")
    system_prompt: str = Field(..., description="System prompt for the LLM (required by API)")
    messages: List[str] = Field(..., description="List of messages as strings (required by API)")


class ChatResult(BaseModel):
    """Single chat result model."""
    result: str = Field(..., description="The response from the LLM")
    model: str = Field(..., description="The model used for this result")
    index: int = Field(..., description="The index of this result (1-based)")


class ChatResponse(BaseModel):
    """Response model for chat endpoint."""
    question: str = Field(..., description="The original question")
    results: List[ChatResult] = Field(..., description="List of top results from the LLM")
    success: bool = Field(default=True, description="Whether the request was successful")
    error: Optional[str] = Field(default=None, description="Error message if any")

