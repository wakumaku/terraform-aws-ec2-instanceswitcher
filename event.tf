locals {
  schedule_types = [
    "start",
    "stop",
    "terminate",
    "reboot",
    "switch",
  ]
}

module "events" {
  for_each = { for st in local.schedule_types : st => st }
  source   = "./event"

  prefix        = var.prefix
  schedules     = var.schedules[each.value]
  schedule_type = each.value
  instance_list = var.instance_list
  lambda_arn    = aws_lambda_function.instanceswitcher.arn
  lambda_name   = aws_lambda_function.instanceswitcher.function_name

  event_bus_name = var.event_bus_name

  tags = local.tags_base
}
