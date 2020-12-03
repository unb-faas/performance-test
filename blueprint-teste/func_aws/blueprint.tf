  provider "aws" {
  region  = "us-east-1"
  shared_credentials_file = "/home/thamires/Documentos/pibic/terraform/lesson9/.aws/credentials"
  profile = "awsterraform"
}

resource "aws_s3_bucket" "b" {
  bucket = "unbfaas"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "index.zip"
  source = "./index.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_lambda_function" "test_lambda" {
  
  function_name = "addReg"
  s3_bucket     = aws_s3_bucket.b.id
  s3_key        = "index.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.addReg"
  runtime       = "nodejs12.x"
  environment {
    variables = {
        DB_HOST = "database-unbfaas.csmwzipzohux.us-east-1.rds.amazonaws.com:3306",
        DB_USER = "databaseunbfaas",
        DB_PASS = "node2faas",
        DB_NAME = "shifts"
    }
  }
}
