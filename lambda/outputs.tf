output "lambda_arn" {
    value = "${aws_lambda_function.test_lambda.arn}"
}

output "invoke_arn" {
    value = "${aws_lambda_function.test_lambda.invoke_arn}"
}