output "lambda_arn" {
  value = "${aws_lambda_function.test_lambda.arn}"
}

output "lambda_version" {
  value = "${aws_lambda_function.test_lambda.version}"
}

output "lambda_source_code_hash" {
  value = "${aws_lambda_function.test_lambda.source_code_hash}"
}

output "lambda_function_name" {
  value = "${aws_lambda_function.test_lambda.function_name}"
}
