# Minecraft Server Automation - Acme Corp

## Background

We replaced a manually deployed Minecraft EC2 instance with a fully automated pipeline using Terraform and Ansible. This new setup ensures reproducibility, ease of management, and resilience (e.g., automatic reboot/startup handling).

## Requirements

To run the automation pipeline, the user should have:

* A valid AWS Academy Learner Lab session with credentials
* A local Unix-based environment (Linux, WSL, or macOS)
* AWS CLI, Terraform, and Ansible installed and configured
* An SSH keypair with the public key used by Terraform for EC2 access

AWS credentials must be set using environment variables or `aws configure`, and the private key must be available locally to allow Ansible to connect.

## Pipeline Overview

This project provisions and configures a Minecraft server on AWS EC2 automatically using the following stages:

1. **Terraform** provisions an EC2 instance and a security group with port 25565 open.
2. **Terraform outputs** the public IP of the instance.
3. A shell script reads the IP and generates an **Ansible inventory file**.
4. **Ansible** installs Java, downloads and configures the Minecraft server, and sets up a `systemd` service.
5. The Minecraft server **automatically restarts on reboot**.

## Diagram of Steps

```
[Local Machine]
   |
   |-- run deploy.sh
   |     |-- terraform init + apply
   |     |-- generate inventory.ini
   |     |-- ansible-playbook provisioning
   v
[AWS EC2 Instance (Minecraft)]
   |-- Java
   |-- Minecraft server JAR
   |-- systemd service (auto-start)
```

## Usage Instructions

To deploy the infrastructure and Minecraft server, run:

```bash
./scripts/deploy.sh
```

This script handles all provisioning and configuration steps.

## Verifying Deployment

To verify that the Minecraft server is running:

```bash
nmap -sV -Pn -p T:25565 $(terraform -chdir=terraform output -raw minecraft_public_ip)
```

Expected output:

```
25565/tcp open  minecraft
```

## Connecting to the Server

* Use the public IP shown by Terraform in your Minecraft client.
* Connect using the default port (25565).
* Optionally reboot the instance and confirm service persistence.

## Resources

* [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Ansible Documentation](https://docs.ansible.com/)
* [Minecraft Server Downloads](https://www.minecraft.net/en-us/download/server)
