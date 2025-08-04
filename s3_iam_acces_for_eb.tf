resource "aws_iam_policy" "eb_s3_policy" {
  name        = "eb-s3-policy"
  description = "Policy for Elastic Beanstalk to access S3"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.deployment_artifacts.arn}/*",
        "${aws_s3_bucket.deployment_artifacts.arn}"
      ]
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "eb_s3_policy_attachment" {
  role       = aws_iam_role.eb_role.name
  policy_arn = aws_iam_policy.eb_s3_policy.arn
}

