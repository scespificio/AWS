# === CONFIGURATION ===
$Region = "eu-west-3"
$KeyPath = "C:\Users\costa\Emilie_key.pem"  # Chemin local vers ta clé privée
$KeyName = "Emilie_key"                    # Nom de la paire de clés dans AWS
$AMI = "ami-0160e8d70ebc43ee1"             # Ubuntu 22.04 LTS - Paris
$InstanceType = "t2.small"
$Username = "ubuntu"
$InstanceName = "test"
$SecurityGroupId = "sg-0dad6fa1356dbcfe0" 
 
# === TAG DE NOM POUR L'INSTANCE ===
$TagSpec = New-Object Amazon.EC2.Model.TagSpecification
$TagSpec.ResourceType = "instance"
$TagSpec.Tags.Add((New-Object Amazon.EC2.Model.Tag -Property @{Key="Name"; Value=$InstanceName}))
$TagSpec.Tags.Add((New-Object Amazon.EC2.Model.Tag -Property @{Key="Owner"; Value="emilie@espificio.com"}))
 
# === LANCEMENT DE L'INSTANCE ===
Write-Host "Création de l'instance EC2..."
$instance = New-EC2Instance -ImageId $AMI -InstanceType $InstanceType -KeyName $KeyName `
    -MinCount 1 -MaxCount 1 -Region $Region -SecurityGroupId $SecurityGroupId -TagSpecification $TagSpec
 
$InstanceId = $instance.Instances[0].InstanceId
Write-Host "Instance lancée : $InstanceId"
 
# === ATTENTE DE L'ÉTAT 'running' ===
Write-Host "Attente que l'instance soit opérationnelle..."
do {
    Start-Sleep -Seconds 10
    $State = (Get-EC2Instance -InstanceId $InstanceId -Region $Region).Instances.State.Name
    Write-Host "État actuel : $State"
} while ($State -ne "running")
 
# === RÉCUPÉRATION DE L'IP PUBLIQUE ===
$PublicIp = (Get-EC2Instance -InstanceId $InstanceId -Region $Region).Instances.PublicIpAddress
Write-Host "`nAdresse IP publique : $PublicIp"


Write-Host "`n=== INFORMATION DE CONNEXION ==="
Write-Host "Votre instance EC2 est prête à être utilisée!"
Write-Host "Pour vous connecter en SSH: ssh -i $KeyPath $Username@$PublicIp"