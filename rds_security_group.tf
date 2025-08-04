resource "aws_security_group" "rds_sg" {
  name        = "soley-rds-sg"
  description = "Security group for the Soley RDS"
  vpc_id      = aws_vpc.soley.id

 ingress {
    description      = "Access from Backend EC2 instances"
    protocol         = "tcp"
    from_port        = 5432
    to_port          = 5432
    security_groups  = [aws_security_group.backend_ec2_sg.id]  # Reference to the Backend EC2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Soley RDS Security Group"
  }
}
