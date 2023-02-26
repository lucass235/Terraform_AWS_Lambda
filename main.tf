provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "my_lambda" {
  filename      = "lambda_function.zip"
  function_name = "user_data_linkedin_lambda"
  role          = aws_iam_role.my_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 3
  memory_size   = 128
  environment {
    variables = {
      LAYER_ARN = aws_lambda_layer_version.example_layer.arn
    }
  }
}

resource "aws_iam_role" "my_lambda" {
  name = "my_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_lambda_permission" "example_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_rest_api" "example_api" {
  name        = "example_api"
  description = "Example API Gateway REST API"
}

resource "aws_api_gateway_resource" "example_resource" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  parent_id   = aws_api_gateway_rest_api.example_api.root_resource_id
  path_part   = "example"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example_api.id
  resource_id   = aws_api_gateway_resource.example_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id             = aws_api_gateway_rest_api.example_api.id
  resource_id             = aws_api_gateway_resource.example_resource.id
  http_method             = aws_api_gateway_method.example_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "example_deployment" {
  rest_api_id = aws_api_gateway_rest_api.example_api.id
  stage_name  = "prod"
}

resource "aws_lambda_layer_version" "example_layer" {
  layer_name = "example_layer"
  compatible_runtimes = ["python3.9"]
  filename = "dependencies.zip"
}

