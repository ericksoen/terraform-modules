resource "aws_api_gateway_rest_api" "demo_api" {
  name        = "${var.gateway_name}"
  description = "${var.gateway_description}"

  binary_media_types = "${var.binary_media_types}"
}

resource "aws_api_gateway_deployment" "deployment" {

    rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
    
    stage_name = "development"
}

resource "aws_api_gateway_method_settings" "s" {
  rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
  stage_name = "${aws_api_gateway_deployment.deployment.stage_name}"

  method_path = "*/*"

  settings {
    logging_level = "INFO"
    data_trace_enabled = true
  }
}