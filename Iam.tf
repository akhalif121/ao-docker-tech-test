data "aws_iam_policy" "Container_Registry" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy" "S3_Access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

data "aws_iam_policy" "ECR_PowerUser" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

data "aws_iam_policy" "Cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchFullAccess"
}

### Code Pipeline IAM Role ###


resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "pipeline-attach" {
  role       = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = data.aws_iam_policy.Container_Registry.arn
}
resource "aws_iam_role_policy_attachment" "pipeline-attach2" {
  role       = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = data.aws_iam_policy.S3_Access.arn
}

resource "aws_iam_role_policy_attachment" "pipeline-attach3" {
  role       = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = data.aws_iam_policy.ECR_PowerUser.arn
}




### Code Build IAM Role ###


resource "aws_iam_role" "codebuild_role" {
  name = "codebuild_service_role"

 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "codebuild-attach" {
  role       = "${aws_iam_role.codebuild_role.name}"
  policy_arn = data.aws_iam_policy.Container_Registry.arn
}

resource "aws_iam_role_policy_attachment" "codebuild-attach2" {
  role       = "${aws_iam_role.codebuild_role.name}"
  policy_arn = data.aws_iam_policy.S3_Access.arn
}

resource "aws_iam_role_policy_attachment" "codebuild-attach3" {
  role       = "${aws_iam_role.codebuild_role.name}"
  policy_arn = data.aws_iam_policy.Cloudwatch.arn
