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
resource "aws_launch_configuration" "schika_AS_launch_config" {
  name_prefix   = "schika_AS_launch_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.key.key_name
  associate_public_ip_address = true
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"

  lifecycle {
    create_before_destroy = true
  }
}
# aws auto scaling group
resource "aws_autoscaling_group" "schika_AS_group" {
  name                 = "schika_AS_group" # name of the auto-scaling group
  launch_configuration = aws_launch_configuration.schika_AS_launch_config.name #the launch configration we want to use for the auto scaling
  min_size             = 1 # least servers we can have.
  max_size             = 2 # max size of our server.
  vpc_zone_identifier  = [aws_subnet.schika_public_1.id, aws_subnet.schika_public_2.id] #subnet to launch our instances.
  health_check_grace_period = 200 # seconds to check our servers health.
  health_check_type         = "EC2" # check for ec2 instance
  force_delete              = true
  load_balancers = [aws_elb.schika-elb.name] #loadbalancer for the instances to spin up.
  # availability_zones = [ "eu-west-1a", "eu-west-1b", "eu-west-1c" ] # availability zone to launch our instances.
  # the availability zones will always clash with the vpc_zone_identifier
  tag {
    key                 = "Name"
    value               = "schika_AS group"
    propagate_at_launch = true
  }  
}

# aws autoscaling policy for alarm trigger
resource "aws_autoscaling_policy" "schika_AS_policy_scaleup" {
  name                   = "schika_AS_policy"
  autoscaling_group_name = aws_autoscaling_group.schika_AS_group.name
  adjustment_type        = "ChangeInCapacity" #when there is a change in capacity
  scaling_adjustment     = "1"  # increase the scaling by one
  cooldown               = "200" #the amount of time to wait before the next scaling
  policy_type            = "SimpleScaling"
}

# cloudwatch to watch over the aws policy before triggering or spining up another instance. (ALARM TRIGGER)
resource "aws_cloudwatch_metric_alarm" "schika_AS_alarm_scaleup" {
  alarm_name          = "schika_AS_alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" #when cpu utilization is greater than 30% scale by creating another instance.

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.schika_AS_group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.schika_AS_policy_scaleup.arn]
}

# when things get balanced, alartm should be triggered to return things to normal
# aws autoscaling policy for alarm trigger
resource "aws_autoscaling_policy" "schika_AS_policy_scaledown" {
  name                   = "schika_AS_policy"
  autoscaling_group_name = aws_autoscaling_group.schika_AS_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # reduce it by one. 
  cooldown               = "200" #the amount of time to wait before the next scaling
  policy_type            = "SimpleScaling"
}

# cloudwatch to watch over the aws policy before triggering or spining up another instance. (ALARM TRIGGER)
resource "aws_cloudwatch_metric_alarm" "schika_alarm_scaledown" {
  alarm_name          = "schika_alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10" #when cpu utilization is greater than 30% scale by creating another instance.

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.schika_AS_group.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.schika_AS_policy_scaledown.arn] #this is the alarm action for scale down.
}