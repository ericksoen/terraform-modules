output "api_gateway_id" {
    value = "${aws_api_gateway_rest_api.demo_api.id}"
}
output "invoke_url" {
    value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}

# output "gateway_integration_uri" {
#     value = "${aws_api_gateway_integration.demo_integration.uri}"
# }