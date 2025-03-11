#!/usr/bin/python3

import os
import sys
from utils import send_slack_message_using_webhook

# Example usage
if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: ./send_slack_webhook.py '<message>'")
        sys.exit(1)

    webhook_url = os.getenv("SLACK_WEBHOOK_URL")
    if not webhook_url:
        print("Error: Slack webhook URL is not defined. Set it as an environment variable SLACK_WEBHOOK_URL and retry.")
        sys.exit(1)

    message = sys.argv[1]

    send_slack_message_using_webhook(webhook_url, message)

