#######
# CloudWatch Events rule to trigger the Lambda function on a schedule resource

resource "aws_cloudwatch_event_rule" "cloudwatch_event_pattern"{
    name = var.cloudwatch_rule_name 
    description = var.cloudwatch_rule_description
    event_pattern = var.event_pattern != "" ? var.event_pattern : null
}


resource "aws_cloudwatch_event_target" "cw_event_lambda_target_scheduler" {
    count = var.create_lambda_target ? length(var.lambda_function_arns) : 0
    rule = aws_cloudwatch_event_rule.cloudwatch_event_pattern.name
    arn  = var.lambda_function_arns[count.index]
}



resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
    count = var.create_lambda_target  ? length(var.lambda_function_arns) : 0
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = var.lambda_function_arns[count.index]
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.cloudwatch_event_pattern.arn}"
}
