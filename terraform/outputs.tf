output "minecraft_public_ip" {
  value       = aws_instance.minecraft.public_ip
  description = "Public IP of the Minecraft server"
}

