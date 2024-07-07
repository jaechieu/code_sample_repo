resource "aws_s3_bucket" "custom_model_bucket" {
  bucket = var.custom_model_bucket
}

resource "aws_s3_bucket" "finetuning_data_bucket" {
  bucket = var.finetuning_data_bucket
}
