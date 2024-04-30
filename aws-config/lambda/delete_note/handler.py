import json
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')

def lambda_handler(event, context):
    try:
        note_id = event['pathParameters']['id']
        response = table.delete_item(
            Key={
                'noteId': note_id
            }
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Note deleted successfully'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
