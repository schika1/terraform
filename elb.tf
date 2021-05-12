#AWS ELB Configuration
resource "aws_elb" "schika-elb" {
  name            = "schika-elb" # name of the elastic loadbalancer
  subnets         = [aws_subnet.schika_public_1.id, aws_subnet.schika_public_2.id] #this is the subnets of where the servers are to be stationed
  security_groups = [aws_security_group.schika-elb-securitygroup.id]
  
  listener {
    instance_port     = 80 #port to connect to in the instance 
    instance_protocol = "http" # protocol to lookout for in the instance
    lb_port           = 80  # open port of the elb for users to connect to
    lb_protocol       = "http" # protocol the users can connect to
  }

  health_check {
    healthy_threshold   = 2 # how many times the health check should be done to certify is healthy. If it pass twices its healthy
    unhealthy_threshold = 2 # how many times the unhealthy check shold be done to certified its unhealthy. If it fails twice, it unhealthy
    timeout             = 3 # time out after 3 times check
    target              = "HTTP:80/" 
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "schika-elb"
  }
}