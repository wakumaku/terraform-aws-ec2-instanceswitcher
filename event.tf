locals {
  action_start     = "start"
  action_stop      = "stop"
  action_terminate = "terminate"
  action_reboot    = "reboot"
  action_switch    = "switch"
}

module "event_start" {
  source = "./event"

  prefix        = var.prefix
  schedules     = var.schedules.start
  schedule_type = local.action_start
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  tags = local.tags_base
}

module "event_stop" {
  source = "./event"

  prefix        = var.prefix
  schedules     = var.schedules.stop
  schedule_type = local.action_stop
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  tags = local.tags_base
}

module "event_reboot" {
  source = "./event"

  prefix        = var.prefix
  schedules     = var.schedules.reboot
  schedule_type = local.action_reboot
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  tags = local.tags_base
}

module "event_terminate" {
  source = "./event"

  prefix        = var.prefix
  schedules     = var.schedules.terminate
  schedule_type = local.action_terminate
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  tags = local.tags_base
}

module "event_switch" {
  source = "./event"

  prefix        = var.prefix
  schedules     = var.schedules.switch
  schedule_type = local.action_switch
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  tags = local.tags_base
}
