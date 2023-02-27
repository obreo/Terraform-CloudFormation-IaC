### Autoscaling with Load Balancer & configuration template

/*
# Prerequisite - Specify the AMI
data "aws_ami" "Amazon_Linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}


# Launch configuration
resource "aws_launch_configuration" "terraform_launch_configuration" {
  name_prefix   = "terraform_launch_configuration"
  image_id      = data.aws_ami.Amazon_Linux.id
  instance_type = "t2.micro"
  key_name      = "Terraform"

  root_block_device {
    volume_size = "8"
  }

  security_groups = [aws_security_group.Terraform_SG.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaling Group
resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "Autoscaling Group"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.terraform_launch_configuration.id
  vpc_zone_identifier       = [aws_subnet.public_subnet2.id, aws_subnet.public_subnet.id]
  target_group_arns         = [aws_lb_target_group.Terraform_LB_Group.id]

  tag {
    key                 = "Purpose"
    value               = "Autoscaling Terraform"
    propagate_at_launch = true
  }
}
*/