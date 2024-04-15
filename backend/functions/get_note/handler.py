import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')

def lambda_handler(event, context):
    try:
        response = table.get_item(
            Key={
                'noteId': event['pathParameters']['noteId']
            }
        )
        item = response.get('Item')
        if not item:
            return {'statusCode': 404, 'body': json.dumps({'error': 'Note not found'})}
        return {
            'statusCode': 200,
            'body': json.dumps(item)
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
