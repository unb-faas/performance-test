provider "aws" {
region  = "us-east-1"
shared_credentials_file = "/home/marcelo.cmotta/.aws/credentials"
#profile = "awsterraform"
}
resource "aws_dynamodb_table" "ddbtable" {
  name             = "myDB"
  hash_key         = "id"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  attribute {
  name = "id"
  type = "S"
  }
}


module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = "my-table"
  hash_key = "id"

  attributes = [
    {
      name = "id"
      type = "N"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}
