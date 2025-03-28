provider "aws" {
  region = "us-east-1"
}
locals {
  current_time = timestamp()
  current_day  = formatdate("YYYY-MM-DD", local.current_time)
  name         = ["new-${local.current_day}", "processed-${local.current_day}"]

}
resource "aws_s3_bucket" "example" {
  bucket = local.name[count.index]
  count  = 2
}
# Creating policy for lambda to provide access on s3 and CW logs ::: 
resource "aws_iam_policy" "lambda-policy" {
  name        = "lambda-policy-${local.current_day}"
  description = "Example IAM policy To access s3 and CW"
  policy      = data.aws_iam_policy_document.policy.json
}

# Creating role for lambda :::   
resource "aws_iam_role" "lambda_role" {
     name = "lambda-role-${local.current_day}"
     assume_role_policy = jsonencode({
     Version = "2012-10-17"
     Statement = [
           {
             Effect = "Allow"
             Principal = {
               Service = "lambda.amazonaws.com"
             }
             Action = "sts:AssumeRole"
           }
         ]
       })
     }


# Attaching role to policy :::
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
     
       role   = aws_iam_role.lambda_role.name
       policy_arn = aws_iam_policy.lambda-policy.arn
       
     }
    

data "archive_file" "python_lambda_package" {  
  type        = "zip"
  output_path = "${path.module}/lambda_function.zip"
  source_dir  = "${path.module}/lambda_function"
}     
# Creating lambda function:::
resource "aws_lambda_function" "lambda_function" {
        function_name = "lambda_function"
        filename      = "lambda_function.zip"
        source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
        role          = aws_iam_role.lambda_role.arn
        runtime       = "python3.9"
        handler       = "hello.lambda_handler"
        timeout       = 20
        depends_on = [ aws_iam_role_policy_attachment.lambda_policy_attachment, aws_s3_bucket.example ]
        environment {
            variables = {
               SOURCE_BUCKET = aws_s3_bucket.example[0].bucket
               DEST_BUCKET   = aws_s3_bucket.example[1].bucket
    }
  }
}
output "test" {
  value = aws_lambda_function.lambda_function.environment
  
}
## creating trigger ######################## 
resource "aws_s3_bucket_notification" "s3-trigger" {
  bucket = "${aws_s3_bucket.example[0].id}"          
  depends_on = [aws_lambda_function.lambda_function]

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.lambda_function.arn}"
    events              = ["s3:ObjectCreated:*"]
   
    
  }
}

resource "aws_lambda_permission" "s3-lambda-permission" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "lambda_function"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.example[0].arn}"
  depends_on = [ aws_lambda_function.lambda_function ]
}

