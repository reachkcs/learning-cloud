import json
import urllib.request
import urllib.error

def lambda_handler(event, context):
    # API Gateway URL
    url = "https://w0o2vjqagg.execute-api.us-east-1.amazonaws.com/prod/myresource"
    
    try:
        # Make GET request to the API Gateway endpoint
        req = urllib.request.Request(url)
        with urllib.request.urlopen(req) as response:
            # Read and decode the response
            response_data = response.read().decode('utf-8')
            
            # Parse the JSON response (assuming the API returns JSON)
            api_response = json.loads(response_data)
            
            # Return a successful response
            return {
                'statusCode': 200,
                'body': json.dumps({
                    'message': 'API call successful!',
                    'api_response': api_response
                })
            }
    
    except urllib.error.HTTPError as e:
        # Handle HTTP errors
        error_message = f"HTTP error occurred: {e.code} - {e.reason}"
        return {
            'statusCode': e.code,
            'body': json.dumps({'message': error_message})
        }
    
    except urllib.error.URLError as e:
        # Handle URL errors (e.g., invalid domain)
        return {
            'statusCode': 500,
            'body': json.dumps({'message': f"URL error: {e.reason}"})
        }
    
    except Exception as e:
        # Handle any other exceptions
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'An error occurred while calling the API.',
                'error': str(e)
            })
        }
