### Setting up a load balancer

# Target Group
resource "aws_lb_target_group" "Terraform_LB_Group" {
  name     = "TerraformLBGroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC_terraform.id
}


# Instances Attcahed to the target group
resource "aws_lb_target_group_attachment" "test" {
  count            = length(aws_instance.Public_Instance)
  target_group_arn = aws_lb_target_group.Terraform_LB_Group.arn
  target_id        = aws_instance.Public_Instance[count.index].id
  port             = 80
}
#___________________________________________________________________________________

# Setting a Load Balancer
resource "aws_lb" "LB" {
  name               = "terraformLb"
  subnets            = [aws_subnet.public_subnet2.id, aws_subnet.public_subnet.id]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.Terraform_SG.id]

  tags = {
    Environment = "Terraform production"
  }
}

# Registering target group with load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Terraform_LB_Group.arn
  }


}