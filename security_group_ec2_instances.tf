## Security group for Frontend EC2 instances
resource "aws_security_group" "frontend_ec2_sg" {
  name        = "soleydash-frontend-sg"
  description = "Security group for the Frontend EC2 instances"
  vpc_id      = aws_vpc.soley.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere, will adjust it later
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.frontend_alb_sg.id] # Reference to the frontend ALB security group
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Backend EC2 Security Group
resource "aws_security_group" "backend_ec2_sg" {
  name        = "soleydash-api-sg"
  description = "Security group for the Backend EC2 instances"
  vpc_id      = aws_vpc.soley.id

  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    cidr_blocks     = ["0.0.0.0/0"]  # Allowing SSH from anywhere, will adjust it later
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.backend_alb_sg.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
# Security Group Rule for Backend EC2 to RDS communication
resource "aws_security_group_rule" "backend_to_rds" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.backend_ec2_sg.id
  protocol                 = "tcp"
  from_port                = 5432
  to_port                  = 5432
  description              = "Allow PostgreSQL traffic from Backend EC2 instances to RDS"
}*/


