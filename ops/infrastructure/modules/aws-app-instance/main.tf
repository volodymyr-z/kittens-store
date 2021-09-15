resource "aws_instance" "INSTANCE_NEW" {
  ami           = data.aws_ami.AWS_AMI_RES.id
  instance_type = "t2.micro"
  associate_public_ip_address = true

  key_name = aws_key_pair.AWS_KEY.key_name
  subnet_id = var.subnet_id
  vpc_security_group_ids = [var.security_group_ids]

  user_data = base64encode(data.template_file.USER_DATA.rendered)

  tags = {
    type = var.project_name
  }

  provisioner "file" {
    source      = "../../docker-compose/docker-compose-remote.yml"
    destination = "/tmp/docker-compose-remote.yml"
  }

   provisioner "remote-exec" {
      scripts = [
#        "../../scripts/install_docker_ec2.sh",
        "../../scripts/run_app_ec2.sh"
        ]
    }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host        = self.public_ip
  }
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

resource "aws_key_pair" "AWS_KEY" {
  key_name = "public-aws-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "template_file" "USER_DATA" {
  template = file("../../templates/app_user_data.sh.tpl")
}
