import os
import asyncio

try:
    GOOGLE_API_KEY = os.environ["GOOGLE_API_KEY"]
    print(" Gemini API key setup complete.")
except Exception as e:
    print(f"Error setting up Gemini API key: {e}")
    exit(1)

from google.adk.agents import Agent
from google.adk.models.google_llm import Gemini
from google.adk.runners import InMemoryRunner
from google.adk.tools import google_search
from google.genai import types

print("ADK components imported successfully.")

retry_config = types.HttpRetryOptions(
    attempts=5,
    exp_base=7,
    initial_delay=1,
    http_status_codes=[429, 500, 503, 504]
)

root_agent = Agent(
    name="helpful_assistant",
    model=Gemini(
        model="gemini-2.5-flash-lite",
        retry_options=retry_config
    ),
    description="A helpful assistant that can answer questions and help with tasks.",
    instruction="You are a helpful assistant. Use Google Search for current info or if unsure",
    tools=[google_search],
)

print("Root agent created successfully.")

runner = InMemoryRunner(agent=root_agent)

print("Runner created.")


async def main():
    response = await runner.run_debug(
        #"What is Agent Development Kit from Google? What languages is the SDK available in?"
        #"What is the current weather in Tokyo?"
        "How is film actor Dharmendra doing right now health wise?"
    )
    print(response)


if __name__ == "__main__":
    asyncio.run(main())