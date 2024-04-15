import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')

def lambda_handler(event, context):
    try:
        data = json.loads(event['body'])
        response = table.update_item(
            Key={
                'noteId': event['pathParameters']['noteId']
            },
            UpdateExpression='SET title = :title, content = :content, lastModified = :date',
            ExpressionAttributeValues={
                ':title': data['title'],
                ':content': data['content'],
                ':date': datetime.utcnow().isoformat()
            },
            ReturnValues='UPDATED_NEW'
        )
        return {
            'statusCode': 200,
            'body': json.dumps(response['Attributes'])
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
