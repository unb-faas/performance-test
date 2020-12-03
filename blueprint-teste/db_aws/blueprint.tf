  provider "aws" {
  region  = "us-east-1"
  shared_credentials_file = "/home/thamires/Documentos/pibic/terraform/lesson9/.aws/credentials"
  profile = "awsterraform"
}

resource "aws_db_instance" "default" {
  allocated_storage = var.allocated_storage
  storage_type = var.storage_type
  engine = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  name = var.name
  username = var.username
  password = var.password
  port = var.port
  identifier = var.identifier
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot = var.skip_final_snapshot 
}
