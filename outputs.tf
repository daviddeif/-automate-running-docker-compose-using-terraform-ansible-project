output "ec2-ip" {
     description = "ip of public"
     value = aws_instance.managed_instance.public_ip
  
}
