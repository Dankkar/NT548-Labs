#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../terraform"

echo "[TEST] terraform fmt"
terraform fmt -check -recursive

echo "[TEST] terraform init"
terraform init

echo "[TEST] terraform validate"
terraform validate

echo "[PASS] Terraform configuration is valid"
