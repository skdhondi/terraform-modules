variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  default     = "us-east-1"
}

variable "cloudwatch_rule_name" {
  description = "The name of the CloudWatch Event Rule"
  default     = "ScheduleEvent"
}

variable "cloudwatch_rule_description" {
  description = "The description of the CloudWatch Event Rule"
  default     = "Schedule Event Trigger."
}

variable "schedule_expression" {
  description = "Schedule expression for the CloudWatch Event Rule"
  default     = "rate(5 minutes)"
}

variable "event_pattern" {
  description = "Event Pattern for CloudWatch Event Rule"
  type = string
  default     = ""
}

variable "lambda_function_arns" {
  description = "List of ARNs of Lambda functions to be added as targets"
  type        = list(string)
  default     = []
}

variable "create_lambda_target" {
  description = "Whether to create a target for the Lambda function (default: true)"
  type        = bool
  default     = true
}
