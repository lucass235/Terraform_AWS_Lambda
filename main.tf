provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "my_lambda" {
  filename      = "lambda_function.zip"
  function_name = "my_lambda1"
  role          = aws_iam_role.my_lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 3
  memory_size   = 128
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

resource "aws_iam_role_policy_attachment" "my_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.my_lambda.name
}

resource "aws_api_gateway_rest_api" "example" {
  name = "api_lambda"
}

resource "aws_api_gateway_resource" "example_root" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "example_method" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.example_root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "example_integration" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.example_root.id
  http_method = aws_api_gateway_method.example_method.http_method

  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}
