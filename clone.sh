#!/bin/bash

rm -rf variables.tf providers.tf .terraform .terraform.lock.hcl

PROFILE=`grep "^\[" ~/.aws/credentials | grep "]$" | tr -d "[" | tr -d "]" | peco`

NAME=`aws ec2 describe-instances --query 'Reservations[*].Instances[*].Tags[?Key ==  \`Name\`].Value' --profile ${PROFILE} | jq -r ".[][][]" | peco`

INSTANCEID=`aws ec2 describe-instances --filters "Name=tag:Name,Values=${NAME}" --profile ${PROFILE} --output text --query 'Reservations[*].Instances[*].InstanceId'`

sed "s/@@PROFILE@@/${PROFILE}/" tmp_providers > providers.tf
sed "s/@@INSTANCEID@@/${INSTANCEID}/" tmp_variables > variables.tf

~/terraform init && ~/terraform plan

~/terraform apply --auto-approve
IMAGEID=`aws ec2 describe-images --filters "Name=name,Values=source-instance" --profile ${PROFILE} | jq -r ".Images[].ImageId"`
aws ec2 deregister-image --image-id ${IMAGEID} --profile ${PROFILE}
