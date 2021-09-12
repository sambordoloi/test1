provider "aws"{ 
  access_key    = "${var.accesskey}"
  secret_key    = "${var.secretkey}"
  region        = "us-east-1"
}

#to create a instance in an exitsing vpc we use datasource

data "aws_vpc" "newname"{
 filter {
     name   = "tag:Name"
     values = ["sam"]
}
}

data "aws_security_group" "sg"{
    filter{
      name   = "tag:Name"
      values = ["sam-sg"]
}
}
resource "aws_instance" "ec2-server" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  count   = 2
  key_name = "samawsnew"
  user_data = file ("install.sh")
  subnet_id = "${var.subnetid}"
  vpc_security_group_ids = ["${data.aws_security_group.sg.id}"]

  tags = {
    Name        = "test-${count.index + 1}"
    Environment = "drest-test-${count.index + 1}"
  }

}
