resource "aws_iam_policy" "rds_restore_policy" {
  name        = "rds-restore-policy"
  description = "Policy to allow RDS to restore schema from S3"

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
    },
    {
      "Effect": "Allow",
      "Action": "rds:RestoreDBInstanceFromS3",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "rds_restore_role" {
  name = "rds-restore-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "rds_restore_policy_attachment" {
  role       = aws_iam_role.rds_restore_role.name
  policy_arn = aws_iam_policy.rds_restore_policy.arn
}