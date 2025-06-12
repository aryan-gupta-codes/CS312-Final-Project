# Minecraft Server Automation - Acme Corp

## 🧠 Background

As part of Acme Corp's infrastructure modernization, we replaced a manually deployed Minecraft EC2 instance with a fully automated provisioning and configuration pipeline. This ensures fast, repeatable deployments with minimal manual intervention and prepares us for future scalability.

## ⚙️ Requirements

To run this infrastructure pipeline locally, ensure the following tools and configuration are in place:

### ✅ Tools

- **Terraform** (v1.5+)
- **Ansible** (v2.14+)
- **AWS CLI** (v2)
- **bash** (for shell scripting)

### 🔧 Installation Steps

#### 1. Install Terraform

```bash
sudo apt update
sudo apt install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

#### 2. Install Ansible

```bash
sudo apt update
sudo apt install -y ansible
```

#### 3. Install AWS CLI

```bash
sudo apt update
sudo apt install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### 🔑 Credentials

- Start your AWS Academy Learner Lab and retrieve your temporary credentials.
- Configure AWS CLI:

```bash
aws configure
# Enter AWS_ACCESS_KEY_ID
# Enter AWS_SECRET_ACCESS_KEY
# Enter AWS_REGION (e.g., us-east-1)
# Leave output format blank or set to json
```

- You must also have a valid **SSH keypair**. To generate one:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/minecraft-key
chmod 600 ~/.ssh/minecraft-key
```

- Ensure the public key (e.g., `minecraft-key.pub`) is referenced in your Terraform `main.tf` for the EC2 instance.

## 🧭 Overview of Steps

1. Terraform provisions:
   - EC2 instance
   - Security group (port 25565 open)
2. Terraform outputs the public IP
3. A deploy script builds an Ansible inventory
4. Ansible installs Java, downloads Minecraft, configures `systemd`
5. Server starts automatically and persists across reboots

## 🔁 Diagram

```
[local machine]
     |
     | Terraform apply
     v
[AWS EC2 + SG + KeyPair] <---+--- Ansible runs over SSH
                              |
                              +--- systemd enables Minecraft
```

## 🚀 How to Deploy

From the root of the repository:

```bash
./scripts/deploy.sh
```

This will:

- Run Terraform
- Output the public IP
- Create an Ansible inventory
- Run the provisioning playbook via SSH

## 🧪 How to Verify

Once deployment is complete:

### 1. Check Minecraft Port

```bash
nmap -sV -Pn -p T:25565 $(terraform -chdir=terraform output -raw minecraft_public_ip)
```

Expect:

```
25565/tcp open  minecraft
```

### 2. Minecraft Client

- Open your Minecraft client
- Add a server using the public IP
- Connect to play

## 🛠 Notes

- To reboot the instance and test service persistence:

```bash
aws ec2 reboot-instances --instance-ids <instance_id> --region us-east-1
```

## 📚 Resources

- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Ansible Documentation](https://docs.ansible.com/)
- [Minecraft Server JAR Downloads](https://www.minecraft.net/en-us/download/server)

