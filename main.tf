provider "aws" {
  access_key    = "${var.accesskey}"
  secret_key    = "${var.secretkey}"
  region        = "us-east-1"
}

resource "aws_instance" "ec2-server" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"
  subnet_id = "${var.subnetid}"
  security_groups = ["${var.sg}"]

  tags = {
    Environment = "drest-test"
  }

}
resource "aws_elb" "loadbalancer" {
  name               = "terraform-elb"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]


  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.sslcert}"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = [aws_instance.web-server.id]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "terraform-elb"
  }
}
resource "aws_db_instance" "mysqldb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "${var.dbuser}"
  password             = "${var.dbpasswd}"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}
