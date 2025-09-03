$InstanceId = "i-0c2c5909e963dd535"
$Region = "eu-west-3"
Remove-EC2Instance -InstanceId $InstanceId -Region $Region -Force:$false
