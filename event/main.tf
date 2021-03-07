variable "prefix" {}
variable "schedule_type" {}
variable "schedules" {}
variable "instance_list" {}
variable "lambda_arn" {}
variable "lambda_name" {}
variable "tags" {}

resource "aws_cloudwatch_event_rule" "instanceswitcher" {
  count               = length(var.schedules)
  name                = "${var.prefix}-instanceswitcher-${var.schedule_type}-${count.index}"
  description         = "Instance Switcher rule: ${var.schedule_type} [${count.index}]"
  schedule_expression = "cron(${var.schedules[count.index]})"

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "instanceswitcher" {
  count     = length(var.schedules)
  target_id = "${var.prefix}-instanceswitcher-${var.schedule_type}-${count.index}"
  rule      = aws_cloudwatch_event_rule.instanceswitcher[count.index].name
  arn       = var.lambda_arn

  input = <<EOF
{
  "instances": ${jsonencode(var.instance_list)},
  "action": "${var.schedule_type}"
}
EOF
}

module "triggers" {
  source        = "./trigger"
  rules_arn     = aws_cloudwatch_event_rule.instanceswitcher.*.arn
  function_name = var.lambda_name
  schedule_type = var.schedule_type
}
