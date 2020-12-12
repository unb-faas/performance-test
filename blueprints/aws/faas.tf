resource "aws_s3_bucket" "b" {
  bucket = "unbfaas"
  acl    = "private"

  tags = {
    Name        = "faas-envaluation"
    Environment = "evaluation"
  }
}

resource "random_string" "random" {
  length = 4
  special = false
  override_special = "/@£$"
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "get.zip"
  source = "../../faas/aws/get/get.zip"
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

resource "aws_iam_policy" "basic-lambda-policy" {
  name        = "basic-lambda-policy-${random_string.random.result}"
  description = "basic-lambda-policy"

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
  name        = "dynamodb-lambda-policy-${random_string.random.result}"
  description = "dynamodb-policy"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "dynamodb:*",
                "dax:*",
                "application-autoscaling:DeleteScalingPolicy",
                "application-autoscaling:DeregisterScalableTarget",
                "application-autoscaling:DescribeScalableTargets",
                "application-autoscaling:DescribeScalingActivities",
                "application-autoscaling:DescribeScalingPolicies",
                "application-autoscaling:PutScalingPolicy",
                "application-autoscaling:RegisterScalableTarget",
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:GetMetricData",
                "datapipeline:ActivatePipeline",
                "datapipeline:CreatePipeline",
                "datapipeline:DeletePipeline",
                "datapipeline:DescribeObjects",
                "datapipeline:DescribePipelines",
                "datapipeline:GetPipelineDefinition",
                "datapipeline:ListPipelines",
                "datapipeline:PutPipelineDefinition",
                "datapipeline:QueryObjects",
                "ec2:DescribeVpcs",
                "ec2:DescribeSubnets",
                "ec2:DescribeSecurityGroups",
                "iam:GetRole",
                "iam:ListRoles",
                "kms:DescribeKey",
                "kms:ListAliases",
                "sns:CreateTopic",
                "sns:DeleteTopic",
                "sns:ListSubscriptions",
                "sns:ListSubscriptionsByTopic",
                "sns:ListTopics",
                "sns:Subscribe",
                "sns:Unsubscribe",
                "sns:SetTopicAttributes",
                "lambda:CreateFunction",
                "lambda:ListFunctions",
                "lambda:ListEventSourceMappings",
                "lambda:CreateEventSourceMapping",
                "lambda:DeleteEventSourceMapping",
                "lambda:GetFunctionConfiguration",
                "lambda:DeleteFunction",
                "resource-groups:ListGroups",
                "resource-groups:ListGroupResources",
                "resource-groups:GetGroup",
                "resource-groups:GetGroupQuery",
                "resource-groups:DeleteGroup",
                "resource-groups:CreateGroup",
                "tag:GetResources",
                "kinesis:ListStreams",
                "kinesis:DescribeStream",
                "kinesis:DescribeStreamSummary"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Action": "cloudwatch:GetInsightRuleReport",
            "Effect": "Allow",
            "Resource": "arn:aws:cloudwatch:*:*:insight-rule/DynamoDBContributorInsights*"
        },
        {
            "Action": [
                "iam:PassRole"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "iam:PassedToService": [
                        "application-autoscaling.amazonaws.com",
                        "dax.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "replication.dynamodb.amazonaws.com",
                        "dax.amazonaws.com",
                        "dynamodb.application-autoscaling.amazonaws.com",
                        "contributorinsights.dynamodb.amazonaws.com",
                        "kinesisreplication.dynamodb.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam-role-policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.basic-lambda-policy.arn
}

resource "aws_iam_role_policy_attachment" "dynamodb-policy" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb-policy.arn
}


resource "aws_lambda_function" "function" {
  
  function_name = "faas-evaluation-get"
  s3_bucket     = aws_s3_bucket.b.id
  s3_key        = "get.zip"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs12.x"
  # environment {
  #   # variables = {
  #   #     # DB_HOST = "database-unbfaas.csmwzipzohux.us-east-1.rds.amazonaws.com:3306",
  #   #     # DB_USER = "databaseunbfaas",
  #   #     # DB_PASS = "node2faas",
  #   #     # DB_NAME = "shifts"
  #   # }
  # }
}



# resource "aws_iam_role" "iam_for_lambda" {
#   name = "iam_for_lambda-${var.region}-${var.name}"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_lambda_function" "function" {
#   filename         = var.sourcecode_zip_path
#   function_name    = "node2faas-${var.name}"
#   description      = "Function ${var.name} automaticly created by node2faas"
#   role             = "${aws_iam_role.iam_for_lambda.arn}"
#   handler          = "${var.name}.${var.name}"
#   source_code_hash = "${filebase64sha256("${var.sourcecode_zip_path}")}"
#   runtime          = "nodejs10.x"
# }

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

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.rest.id
  resource_id             = aws_api_gateway_method.proxy.resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.rest.id
  resource_id   = aws_api_gateway_rest_api.rest.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id             = aws_api_gateway_rest_api.rest.id
  resource_id             = aws_api_gateway_method.proxy_root.resource_id
  http_method             = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.function.invoke_arn
}

resource "aws_api_gateway_deployment" "deploy" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.rest.id
  stage_name  = "faas-evaluation-get"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allowDynDB" {
  statement_id  = "AllowDynamoDBInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal     = "dynamodb.amazonaws.com"
  source_arn    = "${aws_dynamodb_table.ddbtable.arn}/*/*"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:BasicExecution"
  function_name = aws_lambda_function.function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = "arn:aws:events:us-east-1:111122223333:rule/RunDaily"
  qualifier     = aws_lambda_alias.alias.name
}

resource "aws_lambda_alias" "alias" {
  name             = "alias"
  description      = "Alias to get function"
  function_name    = aws_lambda_function.function.function_name
  function_version = "$LATEST"
}

resource "aws_cloudwatch_log_group" "cloudwatchfaas" {
  name = "faas-evaluation-get"

  tags = {
    Environment = "evaluation"
    Application = "faas-evaluation-get"
  }
}

output "function_url" {
  value = aws_api_gateway_deployment.deploy.invoke_url
}

# resource "aws_api_gateway_domain_name" "tf_aws_apigw_domain_for_apis" {
#   //certificate_arn = aws_acm_certificate_validation.example.certificate_arn
#   domain_name     = "api.example.com"
# }

# output faas_url {
#   value = "${aws_api_gateway_domain_name.tf_aws_apigw_domain_for_apis.domain_name}"
#   //sensitive   = true
#   description = "FaaS UrL"
#   //depends_on  = []
# }
