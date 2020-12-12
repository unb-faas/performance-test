resource "aws_s3_bucket" "b" {
  bucket = "unbfaas"
  acl    = "private"

  tags = {
    Name        = "faas-envaluation"
    Environment = "evaluation"
  }
}

resource "aws_iam_role" "faas-evaluation" {
  name = "faas-evaluation"

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

resource "aws_iam_policy" "basic-lambda-policy" {
  # name        = "basic-lambda-policy"
  # description = "basic-lambda-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "dynamodb-policy" {
  # name        = "dynamodb-lambda-policy"
  # description = "dynamodb-policy"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  depends_on = [
    aws_iam_role.faas-evaluation,
  ]
}

resource "aws_iam_role_policy_attachment" "iam-role-policy" {
  role       = aws_iam_role.faas-evaluation.name
  policy_arn = aws_iam_policy.basic-lambda-policy.arn
  depends_on = [
    aws_iam_role.faas-evaluation,
    aws_iam_policy.basic-lambda-policy
  ]
}

resource "aws_iam_role_policy_attachment" "dynamodb-policy" {
  role       = aws_iam_role.faas-evaluation.name
  policy_arn = aws_iam_policy.dynamodb-policy.arn
   depends_on = [
    aws_iam_role.faas-evaluation,
    aws_iam_policy.dynamodb-policy
  ]
}

resource "aws_api_gateway_rest_api" "rest" {
  name        = "evaluation-rest-api"
  description = "REST API for FaaS evaluation automaticly created"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.rest.id
  parent_id   = aws_api_gateway_rest_api.rest.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.rest.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.rest.id
  resource_id   = aws_api_gateway_rest_api.rest.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}