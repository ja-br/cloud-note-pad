provider "aws" {
  region = var.region
}


# Lambda function for creating a note
resource "aws_lambda_function" "create_note" {
  function_name = "CreateNoteLambda"
  handler       = "index.handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/create_note/create_note.zip"
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
      },
    ]
  })
}



# Deployment of API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_note_integration
  ]
  
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  stage_name  = "prod"
}

resource "aws_dynamodb_table" "notes" {
  name           = "Notes"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "noteId"

  attribute {
    name = "noteId"
    type = "S"
  }

  tags = {
    Name = "NotesTable"
  }
}

data "external" "lambda_packager" {
  program = ["bash", "${path.module}/package_lambdas.sh"]
}

