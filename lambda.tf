resource "aws_iam_role" "lambda" {
  name               = "${var.prefix}-instanceswitcher"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  path = var.role_path

  permissions_boundary = var.role_permissions_boundary

  tags = local.tags_base
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.prefix}-instanceswitcher"
  retention_in_days = 14

  tags = local.tags_base
}

# EC2 Actions needed to start/stop instances
resource "aws_iam_policy" "ec2_start_stop" {
  name        = "${var.prefix}-instanceswitcher-start-stop"
  description = "Instance switcher lambda policy to be able to start or stop instances"

  path = var.policies_path

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:StartInstances",
        "ec2:StopInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# EC2 Actions needed to reboot instances
resource "aws_iam_policy" "ec2_reboot" {
  name        = "${var.prefix}-instanceswitcher-reboot"
  description = "Instance switcher lambda policy to reboot instances"

  path = var.policies_path

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:RebootInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# EC2 Actions needed to terminate instances
resource "aws_iam_policy" "ec2_terminate" {
  name        = "${var.prefix}-instanceswitcher-terminate"
  description = "Instance switcher lambda policy to terminate instances"

  path = var.policies_path

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceStatus",
        "ec2:TerminateInstances"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_attach_start_stop" {
  count = (length(var.schedules.start) > 0
    || length(var.schedules.stop) > 0
  || length(var.schedules.switch) > 0 ? 1 : 0)
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.ec2_start_stop.arn
}

resource "aws_iam_role_policy_attachment" "ec2_attach_reboot" {
  count      = (length(var.schedules.reboot) > 0 ? 1 : 0)
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.ec2_reboot.arn
}

resource "aws_iam_role_policy_attachment" "ec2_attach_terminate" {
  count      = (length(var.schedules.terminate) > 0 ? 1 : 0)
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.ec2_terminate.arn
}

resource "aws_lambda_function" "instanceswitcher" {
  filename      = data.archive_file.instanceswitcher.output_path
  function_name = "${var.prefix}-instanceswitcher"
  role          = aws_iam_role.lambda.arn
  handler       = "instanceswitcher.handler"

  source_code_hash = filebase64sha256(data.archive_file.instanceswitcher.output_path)

  runtime = "python3.8"

  tags = local.tags_base
}

data "archive_file" "instanceswitcher" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}
