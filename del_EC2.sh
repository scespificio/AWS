#!/bin/bash

INSTANCE_ID="i-0359ecee409ff16e2"
REGION="eu-west-3"

# Arrêter et terminer l’instance EC2
aws ec2 terminate-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION"
