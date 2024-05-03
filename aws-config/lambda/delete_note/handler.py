# import json
# import boto3
#
# dynamodb = boto3.resource('dynamodb')
# table = dynamodb.Table('Notes')
#
# def lambda_handler(event, context):
#     try:
#         note_id = event['pathParameters']['id']
#         response = table.delete_item(
#             Key={
#                 'noteId': note_id
#             }
#         )
#         return {
#             'statusCode': 200,
#             'body': json.dumps({'message': 'Note deleted successfully'})
#         }
#     except Exception as e:
#         return {
#             'statusCode': 500,
#             'body': json.dumps({'error': str(e)})
#         }


import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Notes')


def lambda_handler(event, context):
    try:
        # Log incoming event to understand what is received by Lambda
        logger.info(f"Received event: {event}")

        note_id = event['pathParameters']['id']
        logger.info(f"Deleting note with ID: {note_id}")

        response = table.delete_item(
            Key={
                'noteId': note_id
            }
        )
        logger.info(f"Delete response: {response}")

        # Check the response from DynamoDB to confirm item was deleted
        if response.get('ResponseMetadata', {}).get('HTTPStatusCode') == 200:
            return {
                'statusCode': 200,
                'body': json.dumps({'message': 'Note deleted successfully'})
            }
        else:
            return {
                'statusCode': 500,
                'body': json.dumps({'error': 'Failed to delete note'})
            }

    except KeyError:
        logger.error(f"'id' not found in pathParameters")
        return {
            'statusCode': 400,
            'body': json.dumps({'error': "Missing 'id' in pathParameters"})
        }
    except Exception as e:
        logger.error(f"Error deleting note: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
