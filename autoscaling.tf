data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
# defining auto scaling group we have to consider the followinig.

# aws key pair to be used to log into the instances
# aws launch configuration for each of the ec2 instance
# aws auto scaling group
# aws autoscaling policy 
# cloudwatch to watch over the aws policy before triggering or spining up another instance.

# aws_key for ec2 instance login.
resource "aws_key_pair" "key" {
  key_name = "key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# aws launch configuration for the ec2 instances.
resource "aws_launch_configuration" "test_launch_config" {
  name_prefix   = "test_launch_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  associate_public_ip_address = true
}
# aws auto scaling group
resource "aws_autoscaling_group" "test_autoscaling" {
  name                 = "test_autoscaling_group"
  launch_configuration = aws_launch_configuration.test_launch_config.name
  min_size             = 1
  max_size             = 2
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  health_check_grace_period = 200
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Test autoscaling group"
    propagate_at_launch = true
  }  
}

# aws autoscaling policy for alarm trigger
resource "aws_autoscaling_policy" "test_autoscaling_policy_scaleup" {
  name                   = "test_autoscaling_policy"
  autoscaling_group_name = aws_autoscaling_group.test_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" 
  cooldown               = "200" #the amount of time to wait before the next scaling
  policy_type            = "SimpleScaling"
}

# cloudwatch to watch over the aws policy before triggering or spining up another instance. (ALARM TRIGGER)
resource "aws_cloudwatch_metric_alarm" "test_alarm_scaleup" {
  alarm_name          = "test_alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" #when cpu utilization is greater than 30% scale by creating another instance.

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.test_autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.test_autoscaling_policy_scaleup.arn]
}

# when things get balanced, alartm should be triggered to return things to normal
# aws autoscaling policy for alarm trigger
resource "aws_autoscaling_policy" "test_autoscaling_policy_scaledown" {
  name                   = "test_autoscaling_policy"
  autoscaling_group_name = aws_autoscaling_group.test_autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # reduce it by one. 
  cooldown               = "200" #the amount of time to wait before the next scaling
  policy_type            = "SimpleScaling"
}

# cloudwatch to watch over the aws policy before triggering or spining up another instance. (ALARM TRIGGER)
resource "aws_cloudwatch_metric_alarm" "test_alarm_scaledown" {
  alarm_name          = "test_alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10" #when cpu utilization is greater than 30% scale by creating another instance.

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.test_autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.test_autoscaling_policy_scaledown.arn]
}