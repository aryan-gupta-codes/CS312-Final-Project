#!/usr/bin/env bash

# Step 1: Run Terraform
cd terraform
terraform apply -auto-approve

# Step 2: Get the public IP
MC_IP=$(terraform output -raw minecraft_public_ip)

# Step 3: Create Ansible inventory file
cd ../ansible
echo "[minecraft]" > inventory.ini
echo "${MC_IP} ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/minecraft-key" >> inventory.ini

# Step 4: Run Ansible playbook
ANSIBLE_HOST_KEY_CHECKING=False \
ansible-playbook -i inventory.ini playbook.yml

