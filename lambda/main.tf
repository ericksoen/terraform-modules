resource "aws_lambda_function" "test_lambda" {
  function_name = "BookApiLambda"

  s3_bucket = "${var.s3_bucket_name}"
  s3_key = "${var.s3_key}"

  role          = "${aws_iam_role.lambda.arn}"
  handler       = "index.handler"

  runtime = "nodejs10.x"
}

resource "aws_iam_role" "lambda" {
  name = "lambda-role"
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



data "aws_iam_policy_document" "cloudwatch_logs" {
    statement {
        effect = "Allow"
        
        actions = [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ]

        resources = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.test_lambda.function_name}:*"
        ]
    }

    statement {
        effect = "Allow"

        actions = [
            "logs:CreateLogGroup"
        ]

        resources = [
            "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"
        ]
    }
}


resource "aws_iam_role_policy_attachment" "provided_policy_attachments" {
    count = "${var.policy_arn_count}"
    
    role = "${aws_iam_role.lambda.name}"
    policy_arn= "${element(var.policy_arns, count.index)}"
}

resource "aws_iam_policy" "cloudwatch_policy" {
    name = "cloudwatch_logs"
    policy = "${data.aws_iam_policy_document.cloudwatch_logs.json}"
}
resource "aws_iam_role_policy_attachment" "cloudwatch_log_attach" {
    role = "${aws_iam_role.lambda.name}"
    policy_arn = "${aws_iam_policy.cloudwatch_policy.arn}"
}

resource "aws_lambda_permission" "apigw_lambda" {
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.test_lambda.function_name}"
    principal = "apigateway.amazonaws.com"

    source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*"
}

resource "aws_cloudwatch_log_group" "logs" {
    name = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
    retention_in_days = 7
}