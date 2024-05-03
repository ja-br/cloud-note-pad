provider "aws" {
  region = var.region
}


# Lambda function for creating a note
resource "aws_lambda_function" "create_note" {
  function_name = "CreateNoteLambda"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/create_note/create_note.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/create_note/create_note.zip")
}

# Lambda function for deleting a note
resource "aws_lambda_function" "delete_note" {
  function_name = "DeleteNoteLambda"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/delete_note/delete_note.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda/delete_note/delete_note.zip")
}

# Lambda function for getting a note
resource "aws_lambda_function" "get_note" {
  function_name = "GetNoteLambda"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/get_note/get_note.zip"
}

# Lambda function for listing notes
resource "aws_lambda_function" "list_notes" {
  function_name = "ListNotesLambda"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/list_notes/list_notes.zip"
}

# Lambda function for updating a note
resource "aws_lambda_function" "update_note" {
  function_name = "UpdateNoteLambda"
  handler       = "handler.lambda_handler"
  runtime       = "python3.10"
  role          = aws_iam_role.lambda_exec_role.arn
  filename      = "${path.module}/lambda/update_note/update_note.zip"
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

resource "aws_iam_policy" "dynamodb_access" {
  name        = "DynamoDBAccessForLambda"
  description = "Allow Lambda functions to access DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan",
          "dynamodb:Query"
        ],
        Resource = "arn:aws:dynamodb:us-east-1:928356223152:table/Notes"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_access_attachment" {
  policy_arn = aws_iam_policy.dynamodb_access.arn
  role       = aws_iam_role.lambda_exec_role.name
}


resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_note.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API"
  source_arn = "${aws_api_gateway_rest_api.NoteTakingAPI.execution_arn}/*/*"
}

# resource "aws_cloudwatch_log_group" "api_gateway_logs" {
#   name              = "/aws/apigateway/my_api_logs"
#   retention_in_days = 7
# }

# Deployment of API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.create_note_integration,
    aws_api_gateway_integration.delete_note_integration,
    aws_api_gateway_integration.get_note_integration,
    aws_api_gateway_integration.list_notes_integration,
    aws_api_gateway_integration.update_note_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
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

# resource "aws_iam_role" "api_gw_cloudwatch" {
#   name               = "api_gw_cloudwatch"
#   assume_role_policy = data.aws_iam_policy_document.api_gw_cloudwatch.json
# }
#
# data "aws_iam_policy_document" "api_gw_cloudwatch" {
#   statement {
#     actions = ["sts:AssumeRole"]
#
#     principals {
#       type        = "Service"
#       identifiers = ["apigateway.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_role_policy" "api_gw_cloudwatch" {
#   name   = "default"
#   role   = aws_iam_role.api_gw_cloudwatch.id
#   policy = data.aws_iam_policy_document.api_gw_cloudwatch_permissions.json
# }
#
# data "aws_iam_policy_document" "api_gw_cloudwatch_permissions" {
#   statement {
#     actions = [
#       "logs:CreateLogGroup",
#       "logs:CreateLogStream",
#       "logs:DescribeLogGroups",
#       "logs:DescribeLogStreams",
#       "logs:PutLogEvents",
#     ]
#
#     resources = ["arn:aws:logs:*:*:*"]
#   }
# }

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
  stage_name    = "prod"

#   access_log_settings {
#     destination_arn = aws_cloudwatch_log_group.api_gateway_logs.arn
#     format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId"
#   }

#   xray_tracing_enabled = true

  tags = {
    Name = "tf-acc-test"
  }
}

data "external" "lambda_packager" {
  program = ["bash", "${path.module}/package_lambdas.sh"]
}

