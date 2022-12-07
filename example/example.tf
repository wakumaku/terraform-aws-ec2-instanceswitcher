terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

# Ec2 instances matching this filter will be affected by the schedule
data "aws_instances" "dev" {
  filter {
    name = "tag:Name"
    values = [
      "dev_1",
      "dev_db",
      "devel_platform",
    ]
  }
}

module "switcher" {
  source = "../."
  # source  = "wakumaku/ec2-instanceswitcher/aws"
  # version = "0.0.6"

  # Prefix to be used in created resources
  prefix = "devel_stack"

  # Which instances will be affected
  instance_list = data.aws_instances.dev.ids

  # Schedules in cron expression format
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html#CronExpressions
  schedules = {
    start = [
      "0 8 ? * MON-FRI *",
      "0 10 ? * SAT,SUN *",
    ]
    stop = [
      "0 18 ? * MON-FRI *",
      "0 16 ? * SAT *",
      "0 14 ? * SUN *",
    ]
    terminate = []
    reboot    = []
    switch    = []
  }

  tags = {
    Name      = "DevMaintenance"
    project   = "operations"
    component = "devmaintainer"
  }
}
