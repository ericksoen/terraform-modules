variable "api_gateway_id" {
  description = "The id of the api gateway with which this lambda should be associated"
}

variable "root_resource_id" {
  description = "The id of the resource that should be associated as the path of the current resource" #TODO: Rough
}

variable "resource_path_part" {
  description = "The resource URL that should be associated with the lambda"
}

variable "http_method" {
  description = "The method by which the API gateway resource can be invoked"
}

variable "policy_arns" {
  description = "The policy ARNs that the lambda can use" # TODO: Rough
  type        = "list"
  default     = []
}

variable "policy_arn_count" {
  description = "The number of policy ARNs that the lambda can use"
}

variable "s3_bucket_name" {
  description = "The name of the bucket that contains the function deployment package"
}

variable "s3_key" {
  description = "The object key that contains the function deployment package"
}

variable "s3_object_version" {
  description = "The object version id to associate with the lambda"
}

variable "function_name" {
  description = "The name of the function"
}

variable "function_handler" {
  description = "The entry point for the function"
}

variable "function_runtime" {
  description = "The runtime language for the function"
  type        = "string"
}

variable "environment_variables" {
  description = "Map of environment variables to use"
  type        = "map"

  default = {}
}

variable "should_publish_version" {
  description = "Use true when you want to publish the lambda as a new version"
  type        = "string"
  default     = "false"
}

variable "function_timeout" {
  description = "The default timeout your lambda should use"
  type        = "string"
  default     = "3"
}
