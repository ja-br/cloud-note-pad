# # API Gateway REST API definition
# resource "aws_api_gateway_rest_api" "NoteTakingAPI" {
#   name        = var.api_name
#   description = "API for managing notes in a serverless note-taking application."
# }
#
# # Resource for 'notes'
# resource "aws_api_gateway_resource" "notes" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   parent_id   = aws_api_gateway_rest_api.NoteTakingAPI.root_resource_id
#   path_part   = "notes"
# }
#
# # POST method to create a note
# resource "aws_api_gateway_method" "notes_post" {
#   rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id   = aws_api_gateway_resource.notes.id
#   http_method   = "POST"
#   authorization = "NONE"
# }
#
# # Lambda integration for POST method
# resource "aws_api_gateway_integration" "create_note_integration" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id = aws_api_gateway_resource.notes.id
#   http_method = aws_api_gateway_method.notes_post.http_method
#   type        = "AWS_PROXY"
#   uri         = aws_lambda_function.create_note.invoke_arn
# }
#
# # GET method to list all notes
# resource "aws_api_gateway_method" "notes_get" {
#   rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id   = aws_api_gateway_resource.notes.id
#   http_method   = "GET"
#   authorization = "NONE"
# }
#
# # Lambda integration for GET method
# resource "aws_api_gateway_integration" "list_notes_integration" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id = aws_api_gateway_resource.notes.id
#   http_method = aws_api_gateway_method.notes_get.http_method
#   type        = "AWS_PROXY"
#   uri         = aws_lambda_function.list_notes.invoke_arn
# }
#
# # Resource for a specific note (e.g., /notes/{noteId})
# resource "aws_api_gateway_resource" "note" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   parent_id   = aws_api_gateway_resource.notes.id
#   path_part   = "{noteId}"
# }
#
# # Methods for specific note resource
# resource "aws_api_gateway_method" "note_get" {
#   rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id   = aws_api_gateway_resource.note.id
#   http_method   = "GET"
#   authorization = "NONE"
# }
#
# resource "aws_api_gateway_method" "note_put" {
#   rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id   = aws_api_gateway_resource.note.id
#   http_method   = "PUT"
#   authorization = "NONE"
# }
#
# resource "aws_api_gateway_method" "note_delete" {
#   rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id   = aws_api_gateway_resource.note.id
#   http_method   = "DELETE"
#   authorization = "NONE"
# }
#
# # Lambda integrations for specific note methods
# resource "aws_api_gateway_integration" "get_note_integration" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id = aws_api_gateway_resource.note.id
#   http_method = aws_api_gateway_method.note_get.http_method
#   type        = "AWS_PROXY"
#   uri         = aws_lambda_function.get_note.invoke_arn
# }
#
# resource "aws_api_gateway_integration" "update_note_integration" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id = aws_api_gateway_resource.note.id
#   http_method = aws_api_gateway_method.note_put.http_method
#   type        = "AWS_PROXY"
#   uri         = aws_lambda_function.update_note.invoke_arn
# }
#
# resource "aws_api_gateway_integration" "delete_note_integration" {
#   rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
#   resource_id = aws_api_gateway_resource.note.id
#   http_method = aws_api_gateway_method.note_delete.http_method
#   type        = "AWS_PROXY"
#   uri         = aws_lambda_function.delete_note.invoke_arn
# }
#
# # Deployment of the API
# resource "aws_api_gateway_deployment" "api_deployment" {
#   depends_on = [
#     aws_api_gateway_rest_api.NoteTakingAPI.id
#     aws_api_gateway_integration.create_note_integration,
#     aws_api_gateway_integration.list_notes_integration,
#     aws_api_gateway_integration.get_note_integration,
#     aws_api_gateway_integration.update_note_integration,
#     aws_api_gateway_integration.delete_note_integration
#
# ]}

# API Gateway to expose RESTful endpoints
resource "aws_api_gateway_rest_api" "NoteTakingAPI" {
  name = "NoteTakingAPI"
  description = "API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Resource for 'notes'
resource "aws_api_gateway_resource" "notes" {
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  parent_id   = aws_api_gateway_rest_api.NoteTakingAPI.root_resource_id
  path_part   = "notes"
}

# Methods for API Gateway (POST)
resource "aws_api_gateway_method" "notes_post" {
  rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "POST"
  authorization = "NONE"
}


# API Gateway Integration for POST method
resource "aws_api_gateway_integration" "create_note_integration" {
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_post.http_method
  integration_http_method = "POST"
  type        = "AWS"
}

resource "aws_api_gateway_method_response" "notes" {
  http_method = aws_api_gateway_method.notes_post.http_method
  resource_id = aws_api_gateway_resource.notes.id
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "notes" {
  http_method = aws_api_gateway_method.notes_post.http_method
  resource_id = aws_api_gateway_resource.notes.id
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  status_code = aws_api_gateway_method_response.notes.status_code

  depends_on = [
    aws_api_gateway_method.notes_post,
    aws_api_gateway_integration.create_note_integration
  ]
}

# Methods for API Gateway (OPTIONS)
resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# API Gateway Integration for OPTIONS method
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.options.http_method
  integration_http_method = "OPTIONS"
  type        = "MOCK"
}

resource "aws_api_gateway_method_response" "options_response" {
  http_method = aws_api_gateway_method.options.http_method
  resource_id = aws_api_gateway_resource.notes.id
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  status_code = "200"

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = true,
      "method.response.header.Access-Control-Allow-Methods" = true,
      "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "options_integration_response" {
  http_method = aws_api_gateway_method.options.http_method
  resource_id = aws_api_gateway_resource.notes.id
  rest_api_id = aws_api_gateway_rest_api.NoteTakingAPI.id
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
      "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
      "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
      "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  depends_on = [
    aws_api_gateway_method.options,
    aws_api_gateway_integration.options_integration
  ]
}