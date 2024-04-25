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

###
### POST
###

# POST Methods
resource "aws_api_gateway_method" "notes_post" {
  rest_api_id   = aws_api_gateway_rest_api.NoteTakingAPI.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "POST"
  authorization = "NONE"
}


# POST Integration
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