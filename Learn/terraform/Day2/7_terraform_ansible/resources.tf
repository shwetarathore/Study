################################### DATA ###############################################

data "aws_availability_zones" "available" {}

data "aws_ami" "aws-linux" {
  most_recent = true  
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

################################### RESOURCES ###############################################

# NETWORKING #
resource "aws_vpc" "vpc" {
  cidr_block           = var.network_address_space
  enable_dns_hostnames = "true"

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

}

resource "aws_subnet" "subnet" {
  cidr_block              = var.subnet_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.available.names[0]

}

# ROUTING #
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta-subnet" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}

# SECURITY GROUPS #

resource "aws_security_group" "aws-sg" {
  name   = "mysecuritygroup"
  vpc_id = aws_vpc.vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "instance1" {
  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet.id
   associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.aws-sg.id]
  key_name               = var.key_name

connection {
    type        = "ssh"
    host        = self.public_ip   ###### IP of the instance itself ######
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

user_data = <<EOF
  #!/bin/bash
    yum update -y
    yum install -y wget git
  EOF

tags = {
    Name = "my-first-instance"
  }
}
resource "null_resource" "install-python" {
depends_on = [aws_instance.instance1]
 provisioner "remote-exec" {
    inline = ["sudo yum install -y python"]
  }

  connection {
      type        = "ssh"
      host        = aws_instance.instance1.public_ip
      user        = var.ssh_user
      private_key = file(var.private_key_path)
    }

  #depends_on = [aws_internet_gateway.igw]

  provisioner "local-exec" {

    working_dir = "./ansible_code"
    command = "ansible-playbook -vD newplaybook.yml"
  }
}

data "template_file" "inventory" {
  template = "${file("${path.module}/templates/inventory.tpl")}"

  vars = {
    connection_string_node     = "${format("%s ansible_host=%s", aws_instance.instance1.public_dns, aws_instance.instance1.public_ip)}"
    ssh_user_string             = "${format("ansible_user=%s", var.ssh_user)}"
    ssh_private_key_path_string = "${format("ansible_ssh_private_key_file='%s'", var.private_key_path)}"
    list_node                   = "${aws_instance.instance1.public_dns}"
  }
}

resource "null_resource" "inventory" {
  provisioner "local-exec" {
    command = "echo '${data.template_file.inventory.rendered}' > /etc/ansible/hosts"
  }

  triggers = {
    template = "${data.template_file.inventory.rendered}"
  }
}


##################################################################################
# OUTPUT
##################################################################################

output "aws_instance_public_dns1" {
  value = aws_instance.instance1.public_dns
  }