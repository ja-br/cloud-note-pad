import json
import boto3
from datetime import datetime
import uuid

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')

def lambda_handler(event, context):
    try:
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
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
