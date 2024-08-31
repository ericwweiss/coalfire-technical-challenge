terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.65.0"
    }
  }

  required_version = ">= 1.9.5"
}

provider "aws" {
  profile = "default"
  region  = var.region
}

#-------------Compute Instance--------------

resource "aws_security_group" "redhat_sg" {
  name        = "redhat-sg"
  description = "Security Group for Web-Facing Instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "redhat_instance" {
  depends_on             = [aws_security_group.redhat_sg]
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.redhat_sg.id]
  subnet_id              = "${element(var.public_subnet_id_list, 1)}"
  root_block_device {
    delete_on_termination = true
    volume_size           = var.ebs_storage
  }

  tags = {
      Environment = var.environment
  }
}


#-------------Autoscaling Group--------------

# Can be used to query for latest Redhat AMI

data "aws_ami_ids" "redhat" {
  owners   = ["self"]

  filter {
    name   = "name"
    values = ["Red Hat Enterprise Linux 9 (HVM)*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "launch_config" {
  name_prefix   = "coalfire-"
  image_id      = var.instance_ami
  instance_type = var.instance_type
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo yum update -y
                  sudo yum install -y httpd.x86_64
                  systemctl start httpd.service
                  systemctl enable httpd.service
                  echo “Hello Coalfire from $(hostname -f)” > /var/www/html/index.html
                  EOF
  security_groups = ["${aws_security_group.autoscaling_sg.id}"]
  root_block_device {
    volume_size = var.ebs_storage
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "autoscaling_sg" {
  name        = "autoscaling_sg"
  description = "Autoscaling Security Group"
  vpc_id      = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http_inbound" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscaling_sg.id
}

resource "aws_security_group_rule" "alb_sg_inbound" {
  type                           = "ingress"
  from_port                      = 80
  to_port                        = 80
  protocol                       = "tcp"
  source_security_group_id       = aws_security_group.alb_sg.id
  security_group_id              = aws_security_group.autoscaling_sg.id
}

resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.autoscaling_sg.id
}

resource "aws_autoscaling_group" "autoscale_group" {
  launch_configuration = "${aws_launch_configuration.launch_config.id}"
  vpc_zone_identifier  = ["${element(var.private_subnet_id_list, 1)}"]
  target_group_arns    = ["${aws_lb_target_group.alb_target_group.arn}"]
  min_size             = 2
  max_size             = 6
  lifecycle {
    ignore_changes     = [load_balancers, target_group_arns]
  }
}

#-------------Application Load Balancer--------------

resource "aws_lb" "alb" {  
  name            = "alb"  
  subnets         = ["${element(var.public_subnet_id_list, 0)}", "${element(var.public_subnet_id_list, 1)}"]
  security_groups = ["${aws_security_group.alb_sg.id}"]
  internal        = false 
  idle_timeout    = 60
}

resource "aws_lb_target_group" "alb_target_group" {  
  name     = "alb-target-group"  
  port     = "80"  
  protocol = "HTTP"  
  vpc_id   = var.vpc_id   
  health_check {    
    healthy_threshold   = 3    
    unhealthy_threshold = 10    
    timeout             = 5    
    interval            = 10    
    path                = "/"    
    port                = 80
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  vpc_id      = var.vpc_id
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_attachment" "alb_autoscale" {
  lb_target_group_arn   = "${aws_lb_target_group.alb_target_group.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.autoscale_group.id}"
}

resource "aws_lb_listener" "alb_listener" {  
  load_balancer_arn = "${aws_lb.alb.arn}"  
  port              = 80  
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = "${aws_lb_target_group.alb_target_group.arn}"
    type             = "forward"  
  }
}
