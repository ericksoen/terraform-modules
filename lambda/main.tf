locals {
  supported_runtimes = {
    "nodejs10.x"    = "nodejs10.x"
    "nodejs8.10"    = "nodejs8.10"
    "python3.7"     = "python3.7"
    "python3.6"     = "python3.6"
    "python2.7"     = "python2.7"
    "go1.x"         = "go1.x"
    "dotnetcore2.1" = "dotnetcore2.1"
    "dotnetcore1.0" = "dotnetcore1.0"
  }

  selected_runtime = "${local.supported_runtimes[var.function_runtime]}"
}

resource "aws_lambda_function" "test_lambda" {
  function_name = "${var.function_name}"

  s3_bucket         = "${var.s3_bucket_name}"
  s3_key            = "${var.s3_key}"
  s3_object_version = "${var.s3_object_version}"

  role    = "${aws_iam_role.lambda.arn}"
  handler = "${var.function_handler}"

  runtime = "${local.selected_runtime}"

  timeout = "${var.function_timeout}"

  environment {
    variables = "${var.environment_variables}"
  }

  publish = "${var.should_publish_version}"
}

resource "aws_iam_role" "lambda" {
  name = "${replace(var.function_name, "_", "-")}-role"
  path = "/service-role/"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 7
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*",
    ]
  }
}

resource "aws_iam_role_policy_attachment" "provided_policy_attachments" {
  count = "${var.policy_arn_count}"

  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${element(var.policy_arns, count.index)}"
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name_prefix = "cloudwatch_logs"
  policy      = "${data.aws_iam_policy_document.cloudwatch_logs.json}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_log_attach" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*"
}

resource "aws_api_gateway_resource" "resource" {
  path_part = "${var.resource_path_part}"

  rest_api_id = "${var.api_gateway_id}"
  parent_id   = "${var.root_resource_id}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"

  http_method   = "${var.http_method}"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.bucket" = true
    "method.request.querystring.key"    = true
  }
}

resource "aws_api_gateway_integration" "demo_integration" {
  rest_api_id = "${var.api_gateway_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${aws_lambda_function.test_lambda.arn}/invocations"
}
