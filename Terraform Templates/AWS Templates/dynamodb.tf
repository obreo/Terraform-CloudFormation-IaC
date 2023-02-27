resource "aws_dynamodb_table" "resume_counter" {
  name             = "NAME"
  hash_key         = "id"
  billing_mode     = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }
}