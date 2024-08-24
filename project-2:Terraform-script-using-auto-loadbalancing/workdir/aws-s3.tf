# # Define the S3 bucket for ALB logs
# resource "aws_s3_bucket" "alb_logs" {
#   bucket = var.alb_access_logs_bucket

#   tags = {
#     Name = "ALB Logs"
#   }
# }

# # Enable versioning on the S3 bucket
# resource "aws_s3_bucket_versioning" "alb_logs" {
#   bucket = aws_s3_bucket.alb_logs.id

#   versioning_configuration {
#     status = "Enabled"
#   }

#   depends_on = [
#     aws_s3_bucket.alb_logs
#   ]
# }

# # IAM Role for ALB to assume
# resource "aws_iam_role" "alb_role" {
#   name = "alb-logging-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "elasticloadbalancing.amazonaws.com"
#         }
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# # Attach policy to allow S3 access
# resource "aws_iam_role_policy" "alb_s3_access_policy" {
#   name   = "alb-s3-access"
#   role   = aws_iam_role.alb_role.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Action = [
#           "s3:PutObject",
#           "s3:PutObjectAcl"
#         ]
#         Resource = "${aws_s3_bucket.alb_logs.arn}/*"
#       }
#     ]
#   })

#   depends_on = [
#     aws_iam_role.alb_role
#   ]
# }

# # S3 Bucket Policy to allow ALB to write logs
# resource "aws_s3_bucket_policy" "alb_logs_policy" {
#   bucket = aws_s3_bucket.alb_logs.id
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid    = "AllowELBRootAccount",
#         Effect = "Allow",
#         Action = "s3:PutObject",
#         Resource = "${aws_s3_bucket.alb_logs.arn}/*",
#         Principal = {
#           Service = "elasticloadbalancing.amazonaws.com"
#         }
#       },
#       {
#         Sid    = "AWSLogDeliveryWrite",
#         Effect = "Allow",
#         Action = "s3:PutObject",
#         Resource = "${aws_s3_bucket.alb_logs.arn}/*",
#         Condition = {
#           StringEquals = {
#             "s3:x-amz-acl" = "bucket-owner-full-control"
#           }
#         },
#         Principal = {
#           Service = "delivery.logs.amazonaws.com"
#         }
#       },
#       {
#         Sid    = "AWSLogDeliveryAclCheck",
#         Effect = "Allow",
#         Action = "s3:GetBucketAcl",
#         Resource = "${aws_s3_bucket.alb_logs.arn}",
#         Principal = {
#           Service = "delivery.logs.amazonaws.com"
#         }
#       },
#       {
#         Sid    = "AllowALBAccess",
#         Effect = "Allow",
#         Action = "s3:PutObject",
#         Resource = "${aws_s3_bucket.alb_logs.arn}/*",
#         Principal = {
#           Service = "elasticloadbalancing.amazonaws.com"
#         }
#       }
#     ]
#   })

#   depends_on = [
#     aws_s3_bucket.alb_logs
#   ]
# }
