#Roles to access the AWS S3 Bucket
resource "aws_iam_role" "s3-role" {
  name               = "s3-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

#Policy to attach the S3 Bucket Role
resource "aws_iam_role_policy" "s3-role-policy" {
  name = "s3-role-policy"
  role = aws_iam_role.s3-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::csamcomapnys3",
              "arn:aws:s3:::csamcomapnys3/*"
            ]
        }
    ]
}
EOF

}

#Instance identifier
resource "aws_iam_instance_profile" "s3-role-instanceprofile" {
  name = "s3-role"
  role = aws_iam_role.s3-role.name
}