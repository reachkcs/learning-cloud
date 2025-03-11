from botocore.exceptions import UnauthorizedSSOTokenError, TokenRetrievalError
import boto3
from colorama import Fore, Style, init
import subprocess
import requests
import json
from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

def check_if_logged_into_aws(aws_region):
    try:
        s3 = boto3.client("s3", region_name=aws_region)
        response = s3.list_buckets()
    except (TokenRetrievalError, UnauthorizedSSOTokenError):
        print(Fore.RED + "\nYour SSO token has expired. Attempting to re-authenticate.")
        print(Style.RESET_ALL)
        # Re-authenticate by running `aws sso login` command
        try:
            result = subprocess.run(["aws", "sso", "login"], check=True)
            print("Re-authentication successful. Retrying operation...")

        except subprocess.CalledProcessError:
            print("Re-authentication failed. Please check your SSO configuration.")
            sys.exit(1)  # Exit if re-authentication fails

def send_slack_message_using_webhook(webhook_url: str, message: str) -> None:
    """
    Send a message to Slack using an incoming webhook URL.

    Parameters:
        webhook_url (str): The Slack webhook URL.
        message (str): The message to send.

    Raises:
        requests.exceptions.RequestException: For HTTP errors.
    """
    payload = {"text": message}

    try:
        response = requests.post(
            webhook_url,
            data=json.dumps(payload),
            headers={"Content-Type": "application/json"}
        )
        if response.status_code != 200:
            raise ValueError(
                f"Request to Slack returned an error {response.status_code}, "
                f"the response is: {response.text}"
            )
        print("Message sent successfully!")
    except requests.exceptions.RequestException as e:
        print(f"Failed to send message: {e}")

def send_slack_message_using_token(token, channel, message):
    """
    Send a message to a Slack channel using a Slack bot token.

    Parameters:
    token (str): The Slack bot token (xoxb-...).
    channel (str): The Slack channel (e.g., #general or channel ID).
    message (str): The message to send.

    Returns:
    None
    """
    client = WebClient(token=token)

    try:
        # Send the message to Slack
        response = client.chat_postMessage(channel=channel, text=message)
        print(f"Message sent to {channel}: {response['ts']}")
    except SlackApiError as e:
        # Print more detailed error information for debugging
        print(f"Error sending message: {e.response['error']}")
        if 'channel' in e.response:
            print(f"Failed channel: {e.response['channel']}")
