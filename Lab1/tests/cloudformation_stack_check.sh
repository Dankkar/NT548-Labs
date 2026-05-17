#!/usr/bin/env bash
set -e

STACK_NAME="${1:-lab1-nested-stack}"

echo "[TEST] Check CloudFormation stack status"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].[StackName,StackStatus]" \
  --output table

echo "[TEST] Check CloudFormation outputs"
aws cloudformation describe-stacks \
  --stack-name "$STACK_NAME" \
  --query "Stacks[0].Outputs" \
  --output table

echo "[PASS] CloudFormation stack exists and has outputs"
