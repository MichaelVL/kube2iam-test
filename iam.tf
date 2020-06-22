locals {
  role_basename = "${var.name_prefix}role"
  policy_basename = "${var.name_prefix}policy"
}


resource "aws_iam_policy" "worker-assume-roles" {
  name        = "${var.name_prefix}worker-assume-roles"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "worker-policy-attach" {
  role       = var.worker_iam_role
  policy_arn = aws_iam_policy.worker-assume-roles.arn
}


resource "aws_iam_role" "role1" {
  name = "${local.role_basename}-1"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": { "AWS": [ "arn:aws:iam::${var.aws_account_id}:root",
                              "arn:aws:iam::${var.aws_account_id}:role/${var.worker_iam_role}"
                            ],
                     "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy1" {
  name        = "${local.policy_basename}-1"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.bucket1.id}",
                    "arn:aws:s3:::${aws_s3_bucket.bucket1.id}/*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach1" {
  role       = aws_iam_role.role1.name
  policy_arn = aws_iam_policy.policy1.arn
}

resource "aws_iam_role" "role2" {
  name = "${local.role_basename}-2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": { "AWS": [ "arn:aws:iam::${var.aws_account_id}:root",
                              "arn:aws:iam::${var.aws_account_id}:role/${var.worker_iam_role}"
                            ],
                     "Service": "ec2.amazonaws.com"
      },
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "policy2" {
  name        = "${local.policy_basename}-2"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Effect": "Allow",
      "Resource": [ "arn:aws:s3:::${aws_s3_bucket.bucket2.id}",
                    "arn:aws:s3:::${aws_s3_bucket.bucket2.id}/*" ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach2" {
  role       = aws_iam_role.role2.name
  policy_arn = aws_iam_policy.policy2.arn
}


output "role1-arn" {
  value = aws_iam_role.role1.arn
}

output "role2-arn" {
  value = aws_iam_role.role2.arn
}
