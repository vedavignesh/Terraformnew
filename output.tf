output "vpc_id" {
  value = aws_vpc.VPC.id
}

output "pubsub_id" {
  value = aws_subnet.PublicSubnet1
}

output "prisub_id" {
  value = aws_subnet.PrivateSubnet1
}