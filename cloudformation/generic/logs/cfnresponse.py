# cfnresponse.py
import json

SUCCESS = 'SUCCESS'
FAILED = 'FAILED'

def send(event, context, status, response_data=None, physical_resource_id=None, no_echo=False):
    response_body = {
        'Status': status,
        'Reason': 'See details in CloudWatch Log Stream: {}'.format(context.log_stream_name),
        'PhysicalResourceId': physical_resource_id or context.log_stream_name,
        'StackId': event.get('StackId'),
        'RequestId': event.get('RequestId'),
        'LogicalResourceId': event.get('LogicalResourceId'),
        'NoEcho': no_echo,
        'Data': response_data or {}
    }

    # Send the response to CloudFormation
    send_response(event['ResponseURL'], response_body)

def send_response(response_url, response_body):
    try:
        import urllib.request
        req = urllib.request.Request(
            response_url,
            data=json.dumps(response_body).encode('utf-8'),
            headers={'Content-Type': 'application/json'},
            method='PUT'
        )
        with urllib.request.urlopen(req) as response:
            response.read()
    except Exception as e:
        print(f"Failed to send response: {e}")

