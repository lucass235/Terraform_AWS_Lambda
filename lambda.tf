resource "aws_lambda_function" "lambda_teraform" {
  filename = "./lambda_function.zip"
  function_name = "lambda_teraform_test"
  role = "arn:aws:iam::123456789012:role/lambda_basic_execution"
  handler = "lambda_teraform_function.lambda_handler"
  runtime = "python3.9"
  source_code_hash = filebase64sha256("./lambda_function.zip")
}