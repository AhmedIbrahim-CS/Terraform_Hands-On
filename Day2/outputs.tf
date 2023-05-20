output "public_ip" {
  value = aws_instance.web[0].public_ip
}

output "private_ip_public_instance" {
  value = aws_instance.web[0].private_ip
}


output "private_ip_private_instance" {
  value = aws_instance.web[1].private_ip
}
