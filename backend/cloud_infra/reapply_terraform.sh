#!/bin/bash
terraform init
terraform apply
rm -rf ./*.zip
rm -rf ../data_validating_lambda/*_zip
rm -rf ../embedding_lambda/*_zip