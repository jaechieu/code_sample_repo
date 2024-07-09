# Variables
variable "myregion" {
  default = "us-west-2"
}

variable "accountId" {
  default = "716436161795"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.myregion
}

variable "custom_model_bucket" {
  description = ""
  type        = string
  default     = "chatbot-custom-model-bucket"
}

variable "finetuning_data_bucket" {
  description = ""
  type        = string
  default     = "chatbot-finetuning-data-bucket"
}

variable "embedding_lambda" {
  description = ""
  type        = string
  default     = "embedding_lambda"
}

variable "embedding_lambda_path" {
  description = ""
  type        = string
  default     = "../embedding_lambda"
}

variable "data_validating_lambda" {
  description = ""
  type        = string
  default     = "data_validating_lambda"
}

variable "data_validating_lambda_path" {
  description = ""
  type        = string
  default     = "../data_validating_lambda"
}



variable "inferencing_lambda" {
  description = ""
  type        = string
  default     = "inferencing_lambda"
}

variable "inferencing_lambda_path" {
  description = ""
  type        = string
  default     = "../inferencing_lambda"
}
