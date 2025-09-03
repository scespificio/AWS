#!/bin/bash

INSTANCE_ID="i-0c2c5909e963dd535"
REGION="eu-west-3"

# Arrêter et terminer l’instance EC2
aws ec2 terminate-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION"
