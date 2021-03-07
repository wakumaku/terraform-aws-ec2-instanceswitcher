variable "rules_arn" {}
variable "function_name" {}
variable "schedule_type" {}

resource "aws_lambda_permission" "trigger" {
  count         = length(var.rules_arn)
  statement_id  = "trigger-${var.schedule_type}-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = var.rules_arn[count.index]
}
