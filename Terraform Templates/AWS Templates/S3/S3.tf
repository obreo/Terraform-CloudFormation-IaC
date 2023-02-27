### S3 Bucket

# Create Bucket
resource "aws_s3_bucket" "myresume_website" {
  bucket = var.bucket_name
  #acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website_conf" {
  bucket = aws_s3_bucket.myresume_website.bucket

# HTML file name
  index_document {
    suffix = var.static_page_file_name
  }
  # Error file name
  #error_document {
  #  key = "error.html"
  #}
}

# Attach Bucket with policy
resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.myresume_website.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}


# Public Access Policy
data "aws_iam_policy_document" "allow_public_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:ListBucket"
      ,"s3:DeleteObject"
      ,"s3:GetObject"
    ]

    resources = [
      #aws_s3_bucket.myresume_website,
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}
