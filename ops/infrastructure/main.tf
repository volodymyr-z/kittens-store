resource "aws_vpc" "VPC" {
  cidr_block = var.cidr_block
  tags = {
    Name = "VPC"
  }
}

resource "aws_internet_gateway" "GW" {
  vpc_id = aws_vpc.VPC.id

  tags = {
    Name = "AWS GW"
  }
}

resource "aws_route_table" "ROUTING_TABLE" {
  vpc_id = aws_vpc.VPC.id

  route {
    cidr_block = var.routing_table_cidr
    gateway_id = aws_internet_gateway.GW.id
  }

  tags = {
    Name = "RoutingTable-public"
  }
}

resource "aws_subnet" "SUBNET" {
  count = 2

  availability_zone = element(data.aws_availability_zones.zones.names, count.index)
  vpc_id = aws_vpc.VPC.id
  cidr_block =  cidrsubnet(var.cidr_block,8,count.index + 1)

  tags = {
    Name = "Subnet-public-${count.index + 1}"
  }
}

resource "aws_security_group" "SECURITY_GROUP_PORTS" {
  name_prefix = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.VPC.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 1234
    to_port          = 1234
    protocol         = "tcp"
    cidr_blocks      = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    description      = "Egress from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

data "aws_availability_zones" "zones" {
  state = "available"
}

resource "aws_key_pair" "AWS_KEY" {
  key_name = "public-aws-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "AWS_AMI_RES" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "template_file" "USER_DATA" {
  template = file("../templates/app_user_data.sh.tpl")
}

resource "aws_instance" "INSTANCE_NEW" {
  ami           = data.aws_ami.AWS_AMI_RES.id
  instance_type = "t2.micro"
  associate_public_ip_address = true

  key_name = aws_key_pair.AWS_KEY.key_name
  subnet_id = aws_subnet.SUBNET.0.id
  vpc_security_group_ids = [aws_security_group.SECURITY_GROUP_PORTS.id]

  user_data = base64encode(data.template_file.USER_DATA.rendered)

  tags = {
    type = "new-instance-test"
  }

  provisioner "file" {
    source      = "../../docker-compose-remote.yml"
    destination = "/tmp/docker-compose-remote.yml"
  }


//  provisioner "remote-exec" {
//    scripts = [
//      "../scripts/install_docker_ec2.sh",
//      "../scripts/run_app_ec2.sh"
//      ]
//  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }

  depends_on = [
    aws_security_group.SECURITY_GROUP_PORTS
  ]
}

resource "aws_route_table_association" "ROUTE_TABLE" {
  count = 2

  subnet_id      = element(aws_subnet.SUBNET[*].id, count.index)
  route_table_id = aws_route_table.ROUTING_TABLE.id
}
