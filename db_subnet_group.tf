#updatesubnetgroup
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "soley-rds-subnet-group"
  subnet_ids = [aws_subnet.soley-private-subnet-1.id, aws_subnet.soley-private-subnet-2.id]

  tags = {
    Name = "Soley RDS Subnet Group"
  }
}
