resource "aws_s3_bucket" "remote_state" {
  bucket        = "seal-remote-state"
  force_destroy = true
  tags = {
    Name        = "seal-remote-state"
    Environment = var.env
  }
}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "SealRemoteState"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockId"

  attribute {
    name = "LockId"
    type = "S"
  }

  tags = {
    Name        = "seal-remote-state"
    Environment = var.env
  }
}
