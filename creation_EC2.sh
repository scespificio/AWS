#!/bin/bash

# === CONFIGURATION ===
REGION="eu-west-3"
KEY_PATH="/Users/stevecostalat/.ssh/scespificio.pem"    # Chemin local vers la clé privée
KEY_NAME="scespificio"                        # Nom de la paire de clés AWS
AMI="ami-0160e8d70ebc43ee1"                  # Ubuntu 22.04 LTS - Paris
INSTANCE_TYPE="t2.small"
USERNAME="ubuntu"
INSTANCE_NAME="test"
SECURITY_GROUP_ID="sg-0dad6fa1356dbcfe0"     # Remplace si nécessaire

# === LANCEMENT DE L'INSTANCE ===
echo "Création de l'instance EC2..."
INSTANCE_INFO=$(aws ec2 run-instances \
  --image-id "$AMI" \
  --count 1 \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_NAME" \
  --security-group-ids "$SECURITY_GROUP_ID" \
  --region "$REGION" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME},{Key=Owner,Value=emilie@espificio.com}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

INSTANCE_ID="$INSTANCE_INFO"
echo "Instance lancée : $INSTANCE_ID"

# === ATTENTE DE L'ÉTAT 'running' ===
echo "Attente que l'instance soit opérationnelle..."
while true; do
    STATE=$(aws ec2 describe-instances \
      --instance-ids "$INSTANCE_ID" \
      --region "$REGION" \
      --query 'Reservations[0].Instances[0].State.Name' \
      --output text)

    echo "État actuel : $STATE"
    if [ "$STATE" == "running" ]; then
        break
    fi
    sleep 10
done

# === RÉCUPÉRATION DE L'IP PUBLIQUE ===
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --region "$REGION" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo
echo "Adresse IP publique : $PUBLIC_IP"
echo
echo "=== INFORMATION DE CONNEXION ==="
echo "Votre instance EC2 est prête à être utilisée!"
echo "Pour vous connecter en SSH :"
echo "ssh -i \"$KEY_PATH\" $USERNAME@$PUBLIC_IP"
