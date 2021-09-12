output "aws_vpc_id"{
   value = "${data.aws_vpc.newname.id}"
}
output "instance_public_ip" {  
   description = "Public IP address of the EC2 instance"  
   value       = aws_instance.ec2-server.*.public_ip
}
