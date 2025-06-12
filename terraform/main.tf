provider "aws" {
  region = "us-east-1"
}

# Key pair (expects you have a public key file locally)
resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-key"
  public_key = file("~/.ssh/minecraft-key.pub")  # Make sure this path is correct
}

# Security group for SSH and Minecraft traffic
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg-1"
  description = "Allow SSH and Minecraft traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your IP for security
  }

  ingress {
    description = "Minecraft"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "minecraft" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu Server 24.04 LTS in us-east-1
  instance_type          = "t2.small"
  key_name               = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "MinecraftServer"
  }
}

# Output the instance public IP
# output "minecraft_public_ip" {
#  value = aws_instance.minecraft.public_ip
#  description = "Public IP of the Minecraft server"
#}

