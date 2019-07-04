variable "api_gateway_id" {
    description = "The id of the api gateway with which this lambda should be associated"
}

variable "policy_arns" {
    description = "The policy ARNs that the lambda can use" # TODO: Rough
    type = "list"
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