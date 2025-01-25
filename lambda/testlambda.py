import json
import os
import requests

def lambda_handler(event, context):
    print("Received event:", json.dumps(event, indent=2))

    # Construct the API Gateway URL using environment variables
    api_gateway_url = f"https://{os.environ['API_GATEWAY_ID']}.execute-api.{os.environ['AWS_REGION']}.amazonaws.com/prod/myresource"
    
    try:
        # Make a GET request to the API Gateway resource
        response = requests.get(api_gateway_url)
        
        # Log the API Gateway response
        print("API Gateway response:", response.json())
        
        # Return the response data from the API Gateway
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Lambda successfully called the API Gateway!',
                'apiGatewayResponse': response.json()
            })
        }
    except Exception as e:
        print("Error calling API Gateway:", str(e))
        
        # Return error response if the API call fails
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Failed to call the API Gateway',
                'error': str(e)
            })
        }
