#!/usr/bin/python3

import argparse
import os
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError
from utils import send_slack_message_using_token

def main():
    # Create the argument parser
    parser = argparse.ArgumentParser(description="Send a message to Slack using a bot token.")

    # Add arguments for the channel and message
    parser.add_argument("channel", help="The Slack channel (e.g., #general or channel ID)")
    parser.add_argument("message", help="The message to send to the Slack channel")

    # Parse the command-line arguments
    args = parser.parse_args()

    # Get the token from the environment variable if not provided as a command-line argument
    slack_token = os.getenv("SLACK_TOKEN")

    if not slack_token:
        print("Error: Slack bot token is required. Please provide it as an environment variable or command-line argument.")
        return

    # Send the message
    send_slack_message_using_token(slack_token, args.channel, args.message)

if __name__ == "__main__":
    main()

