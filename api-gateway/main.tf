resource "aws_api_gateway_rest_api" "demo_api" {
  name        = "BooksApiLambda"
  description = "Get books"
}

resource "aws_api_gateway_resource" "demo_resource" {
  path_part = "books"

  rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.demo_api.root_resource_id}"

}

resource "aws_api_gateway_method" "demo_method" {
  rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
  resource_id = "${aws_api_gateway_resource.demo_resource.id}"

  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "demo_integration" {
  rest_api_id          = "${aws_api_gateway_rest_api.demo_api.id}"
  resource_id          = "${aws_api_gateway_resource.demo_resource.id}"
  http_method          = "${aws_api_gateway_method.demo_method.http_method}"

  integration_http_method                 = "POST"
    type = "AWS_PROXY"

  uri = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
}

resource "aws_api_gateway_method_response" "gateway_method_response" {
  rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
  resource_id = "${aws_api_gateway_resource.demo_resource.id}"
  http_method = "${aws_api_gateway_method.demo_method.http_method}"
  status_code = "200"

}

resource "aws_api_gateway_model" "bucket_policy_model" {
  rest_api_id  = "${aws_api_gateway_rest_api.demo_api.id}"
  name         = "BucketPolicy"
  description  = "sample schema"
  content_type = "application/json"

  schema = <<EOF
  {
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title" : "Empty Schema",
    "type" : "object",
    "properties": {
        "bucket_name": {"type": "string" }
    }
  }
  EOF
}

resource "aws_api_gateway_deployment" "deployment" {
    depends_on = ["aws_api_gateway_integration.demo_integration"]

    rest_api_id = "${aws_api_gateway_rest_api.demo_api.id}"
    
    stage_name = "development"
}