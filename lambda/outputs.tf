output "lambda_arn" {
    value = "${aws_lambda_function.test_lambda.arn}"
}

output "invoke_arn" {
    value = "${aws_lambda_function.test_lambda.invoke_arn}"
}

output "lambda_version" {
    value = "${aws_lambda_function.test_lambda.version}"
}

output "lambda_last_modified" {
    value = "${aws_lambda_function.test_lambda.last_modified}"
}