# Here I am not using this data source but we can use the same in aws_iam_policy : See the commented line 
data "aws_arn" "s3_instance" {
  arn   = aws_s3_bucket.example[count.index].arn
  count = 2
}



data "aws_iam_policy_document" "policy" {
     statement {
        
             effect = "Allow"
             actions = [
                "s3:GetObject",
                "s3:PutObject"
            ]
            resources = [for bucket in resource.aws_s3_bucket.example : "${bucket.arn}/*"]
            #resources = [for bucket in data.aws_arn.s3_instance : "${bucket.arn}/*"]
        }
      statement {
        
             effect = "Allow"
             actions = [
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:CreateLogStream"
            ]
            resources = ["arn:aws:logs:*:*:*"]
          
        }  
     }



 
     