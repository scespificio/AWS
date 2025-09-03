#!/bin/bash

# Variables à personnaliser
AWS_ACCESS_KEY="VOTRE_ACCESS_KEY"
AWS_SECRET_KEY="VOTRE_SECRET_KEY"
AWS_REGION="eu-west-3"   # ou la région de ton choix
AWS_PROFILE="default"

# Configuration des credentials
aws configure set aws_access_key_id "$AWS_ACCESS_KEY" --profile "$AWS_PROFILE"
aws configure set aws_secret_access_key "$AWS_SECRET_KEY" --profile "$AWS_PROFILE"
aws configure set region "$AWS_REGION" --profile "$AWS_PROFILE"
aws configure set output "json" --profile "$AWS_PROFILE"

echo "Profil AWS '$AWS_PROFILE' configuré avec succès."
