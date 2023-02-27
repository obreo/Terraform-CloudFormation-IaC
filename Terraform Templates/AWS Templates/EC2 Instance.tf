# Two Public Instances
resource "aws_instance" "Public_Instance" {
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.Terraform_SG.id]
  ami                         = "ami-0b5eea76982371e91"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  root_block_device {
    volume_size = "8"
  }
  key_name  = "Terraform"
  count     = 2
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update
    sudo yum install httpd
    sudo service httpd start
    sudo service httpd enable
    sudo echo "This was created using Terraform" >> /var/www/html/index.html
    EOF

  tags = {
    Name = "Public EC2"
  }
}

/*
# Single private instance
resource "aws_instance" "Private_instance" {
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.Terraform_SG.id]
  ami                    = "ami-0b5eea76982371e91"
  instance_type          = "t2.micro"
  root_block_device {
    volume_size = "8"
  }
  key_name = "Terraform"

  tags = {
    Name = "Private EC2"
  }
}
*/