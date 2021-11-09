data "aws_kms_alias" "kmskey" {
  name = "alias/aws/s3"
}


### Code Pipeline ###

resource "aws_codepipeline" "codepipeline" {
    name            = "ao-mm-pipeline"
    role_arn        = "${aws_iam_role.codepipeline_role.arn}"

    artifact_store {
        location = "${aws_s3_bucket.codepipeline_bucket.id}"
        type     = "S3"

    encryption_key {
        id   = data.aws_kms_alias.kmskey.name
        type = "KMS"
    }
  }

    stage {
    name = "Source"

    action {
      name             = "AOApp"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${aws_s3_bucket.codepipeline_bucket.id}"]

    configuration = {
        Owner      = "MPM3278"
        Repo       = "https://github.com/MPM3278/ao-docker-tech-test"
        Branch     = "ao"
        OAuthToken = "${aws_codebuild_source_credential.github-mpm3278.id}"
      }

    }
  }


    stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["${aws_s3_bucket.codepipeline_bucket.id}"]

      configuration = {
        ProjectName = "ao-mm-pipeline"
      }
    }
  }

    stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts  = ["${aws_s3_bucket.codepipeline_bucket.id}"]

    configuration = {
        ClusterName = "ao-mm-cluster"
        ServiceName = "ao-mm-ecs-nginx"
      }
    }
  }

}
