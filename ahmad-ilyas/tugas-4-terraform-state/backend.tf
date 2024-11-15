# resource "aws_s3_bucket" "remote_state" {
#   bucket        = "seal-remote-state-copy-duty"
#   force_destroy = true
#   tags = {
#     Name        = "seal-remote-state-copy-duty"
#     Environment = var.env
#   }
# }

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "SealRemoteState"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name        = "seal-remote-state-copy-duty"
    Environment = var.env
  }
}
