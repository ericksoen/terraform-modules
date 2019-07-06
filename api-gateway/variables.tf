variable "lambda_arn" {
    description = "The ARN of the lambda function that the integration should call"
}

variable "binary_media_types" {
    description = "The binary media types this API accepts"
    type = "list"
    default = []
}
variable "gateway_name" {
    description = "The name to assign to the API gateway"
}

variable "gateway_description"{
    description = "The purpose of the gateway"
} 
