#!/bin/bash

# INSTANCE_ID=$(aws ec2 run-instances --image-id ami-0b69ea66ff7391e80 --count 1 --region us-east-1 --instance-type $1 --key-name $4 --availability-zone us-east-1a --security-group-ids $3 --subnet-id $2 --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$5}}]" --query 'Instances[0].InstanceId' --output text)

# create arguments for the following next time
# subnet

# ----------------------------------- help ----------------------------------- #
if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ -z "$1" ]; then
# if [ "$1" == "help" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ] || [ -$# -ne 5 ]; then
    echo "Usage: $0 <1-region> <2-instance_type> <3-key_name.pem> <4-volume_size> <5-tag>"
    exit 1
fi

# --------------------------------- key pair --------------------------------- #
# 1. check if the key indicated with path / if true remove the path
if [[ $3 == *"/"* ]]; then
    key_name=$(echo $3 | awk -F "/" '{print $NF}')
else
    key_name=$3
fi
# 2. check if the key does not exist in the region and create it if not
if [ -z "$(aws ec2 describe-key-pairs --region $1 --key-names $key_name > /dev/null)"]; then
    # aws ec2 describe-key-pairs --region eu-central-1 --query 'KeyPairs[*].KeyName' >/dev/null || aws ec2 create-key-pair --region $1 --key-name $key_name --query 'KeyMaterial' --output text > $3
    aws ec2 create-key-pair --region $1 --key-name $key_name --query 'KeyMaterial' --output text > $3
    chmod 400 $3
fi
# --------------------------------- image id --------------------------------- #
# 1. get the 20.04 ubuntu ami
ubuntu_ami=$(aws ec2 describe-images --region $1 --owners 099720109477 --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" --query 'Images[*].ImageId' | grep "ami-" | sed 's/ //g' | sort -u | awk 'NR==20' | sed 's/,//g' | sed 's/"//g')

# --------------------------- create security group -------------------------- #
# 1. create new sg
sg=$(aws ec2 create-security-group --region $1 --group-name $5 --description "allow all traffic from the my ip only to instance" | grep "GroupId" | sed 's/ //g' | sed 's/"//g' | sed 's/,//g' | sed 's/GroupId://g' | sed 's/{//g' | sed 's/}//g')
# or add an existing sg
# aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --groups <sg>
clear && echo "Creating new security group with custom inbound rule to allow all traffic from current ip..." && echo 
sleep 5
# 2. add inbound rule to instance security group to allow all traffic from the current ip
MY_IP=$(curl -s https://api.ipify.org)
aws ec2 authorize-security-group-ingress --region $1 --group-id $sg --protocol all --port all --cidr $MY_IP/32

# ------------------------------ create instance ----------------------------- #
# create instance and save the instance id
INSTANCE_ID=$(aws ec2 run-instances --image-id $ubuntu_ami --count 1 --region $1 --instance-type $2 --key-name $key_name --security-group-ids $sg --block-device-mappings "[{\"DeviceName\":\"/dev/sda1\",\"Ebs\":{\"VolumeSize\":$4}}]" --query 'Instances[0].InstanceId' --output text)
sleep 1 && clear && echo "Security group $sg created"
echo -e "Creating instance $INSTANCE_ID, keep calm and wait for 10 seconds..."
sleep 10

# ------------------------------- get public ip ------------------------------ #
PUBLIC_IP=$(aws ec2 describe-instances --region $1 --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo && echo "Instance $INSTANCE_ID is running with public ip $PUBLIC_IP"


# ---------------------------------- add tag --------------------------------- #
aws ec2 create-tags --region $1 --resources $INSTANCE_ID --tags Key=Name,Value=$5
echo && echo "tag $5 added to instance $INSTANCE_ID" && echo


# -------------------------------- add subnet -------------------------------- #
# aws ec2 modify-instance-attribute --instance-id $INSTANCE_ID --subnet-id $4

# ----------------------- wait for ssh to be available ----------------------- #
while ! nc -z $PUBLIC_IP 22; do
    sleep 2
done

# ---------- stop and enable virtualization then start the instance ---------- #
aws ec2 stop-instances --region $1 --instance-ids $INSTANCE_ID
aws ec2 wait instance-stopped --region $1 --instance-ids $INSTANCE_ID && echo "stopped"
aws ec2 modify-instance-attribute --region $1 --instance-id $INSTANCE_ID --ena-support
aws ec2 start-instances --region $1 --instance-ids $INSTANCE_ID
aws ec2 wait instance-running --region $1 --instance-ids $INSTANCE_ID && echo "running"
PUBLIC_IP=$(aws ec2 describe-instances --region $1 --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo && echo "Instance $INSTANCE_ID is running with public ip $PUBLIC_IP"


# ------------------------------ ssh to instance ----------------------------- #
ssh -o StrictHostKeyChecking=no -i $3 ubuntu@$PUBLIC_IP
