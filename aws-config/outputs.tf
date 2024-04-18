# Output the API Gateway URL
output "api_url" {
  value       = "${aws_api_gateway_deployment.api_deployment.invoke_url}/prod"
  description = "The URL to access the deployed API Gateway endpoint."
}

# Output the ARN of the API Gateway
output "api_gateway_arn" {
  value       = aws_api_gateway_rest_api.NoteTakingAPI.execution_arn
  description = "ARN of the API Gateway."
}

# Output the ARN for each Lambda function
output "create_note_lambda_arn" {
  value       = aws_lambda_function.create_note.arn
  description = "ARN of the Lambda function for creating notes."
}

# Output the IAM role ARN for Lambda execution
output "lambda_exec_role_arn" {
  value       = aws_iam_role.lambda_exec_role.arn
  description = "ARN of the IAM role used for Lambda function execution."
}

# Optional: Output the ID of the DynamoDB table if used
output "dynamodb_table_id" {
  value       = aws_dynamodb_table.notes.id
  description = "The ID of the DynamoDB table used for storing notes."
}
