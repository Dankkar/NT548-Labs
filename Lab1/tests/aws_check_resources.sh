#!/usr/bin/env bash
set -e

VPC_ID="$1"

if [ -z "$VPC_ID" ]; then
  echo "Usage: ./aws_check_resources.sh <vpc-id>"
  exit 1
fi

echo "[TEST] Check VPC"
aws ec2 describe-vpcs \
  --vpc-ids "$VPC_ID" \
  --query "Vpcs[*].[VpcId,CidrBlock,State]" \
  --output table

echo "[TEST] Check Subnets"
aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,MapPublicIpOnLaunch]" \
  --output table

echo "[TEST] Check Route Tables"
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "RouteTables[*].[RouteTableId,Associations[0].Main]" \
  --output table

echo "[TEST] Check Routes"
aws ec2 describe-route-tables \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "RouteTables[*].Routes[*].[DestinationCidrBlock,GatewayId,NatGatewayId,State]" \
  --output table

echo "[TEST] Check Security Groups"
aws ec2 describe-security-groups \
  --filters "Name=vpc-id,Values=$VPC_ID" \
  --query "SecurityGroups[*].[GroupId,GroupName]" \
  --output table

echo "[PASS] AWS resources exist"
