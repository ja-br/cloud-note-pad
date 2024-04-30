# import json
# import boto3
# from datetime import datetime
# import uuid
#
# dynamodb = boto3.resource('dynamodb')
# table = dynamodb.Table('Notes')
#
# def lambda_handler(event, context):
#     try:
#         data = json.loads(event['body'])
#         note_id = str(uuid.uuid4())
#         item = {
#             'noteId': note_id,
#             'title': data['title'],
#             'content': data['content'],
#             'lastModified': datetime.utcnow().isoformat()
#         }
#         table.put_item(Item=item)
#         return {
#             'statusCode': 200,
#             'body': json.dumps(item)
#         }
#     except Exception as e:
#         return {
#             'statusCode': 500,
#             'body': json.dumps({'error': str(e)})
#         }
#
import json
import boto3
from datetime import datetime
import uuid
import logging

# Setup basic logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')

def lambda_handler(event, context):
    try:
        logger.info(f"Received event: {event}")  # Log the incoming event structure
        # Check if 'body' exists and is not empty
        if 'body' not in event or not event['body']:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing body'})
            }
        data = json.loads(event['body'])
        note_id = str(uuid.uuid4())
        item = {
            'noteId': note_id,
            'title': data['title'],
            'content': data['content'],
            'lastModified': datetime.utcnow().isoformat()
        }
        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }
    except json.JSONDecodeError as e:
        logger.error(f"JSON decode error: {str(e)}")
        return {
            'statusCode': 400,
            'body': json.dumps({'error': 'Invalid JSON format'})
        }
    except KeyError as e:
        logger.error(f"Missing key in data: {str(e)}")
        return {
            'statusCode': 400,
            'body': json.dumps({'error': f'Missing key: {str(e)}'})
        }
    except Exception as e:
        logger.error(f"Unhandled error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
