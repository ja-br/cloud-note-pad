# Define the AWS region
variable "region" {
  type        = string
  description = "AWS region where the resources will be deployed."
  default     = "us-east-1"
}

# Define common tags to apply to all resources
variable "common_tags" {
  type        = map(string)
  description = "Common tags to apply to all AWS resources."
  default     = {
    Terraform   = "true"
    Environment = "production"
  }
}

# Variables for API Gateway
variable "api_name" {
  type        = string
  description = "Name of the API Gateway API."
  default     = "NoteTakingAPI"
}

# Variables for Lambda functions
variable "lambda_runtime" {
  type        = string
  description = "Runtime for AWS Lambda functions."
  default     = "python3.10"
}

variable "lambda_handler" {
  type        = string
  description = "Handler for the Lambda function."
  default     = "index.handler"
}

# Variable for the S3 bucket name for Lambda deployment packages
variable "lambda_s3_bucket" {
  type        = string
  description = "S3 bucket name where Lambda deployment packages are stored."
  default = "notes-lambdas"
}

# Variable for Lambda function names
variable "create_note_lambda_name" {
  type        = string
  description = "Function name for creating a note."
  default     = "CreateNoteLambda"
}

# IAM role variables
variable "iam_role_lambda_exec_name" {
  type        = string
  description = "Name of the IAM role for Lambda execution."
  default     = "lambda_exec_role"
}
