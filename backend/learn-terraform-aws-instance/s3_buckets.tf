variable "custom_model_bucket" {
  description = ""
  type        = string
  default     = "chatbot-custom-model-bucket"
}

resource "aws_s3_bucket" "custom_model_bucket" {
  bucket = var.custom_model_bucket
}

variable "finetuning_data_bucket" {
  description = ""
  type        = string
  default     = "chatbot-finetuning-data-bucket"
}

resource "aws_s3_bucket" "finetuning_data_bucket" {
  bucket = var.finetuning_data_bucket
}
