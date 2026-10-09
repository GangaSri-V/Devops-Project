resource "aws_instance" "ec2-1" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = "t3.micro"
  subnet_id   = aws_subnet.public_sub_1.id
  key_name = "ec2-keypair"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = "true"

user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y docker
systemctl enable --now docker
EOF

  tags = {
    Name = "devops_ec2_1"
  }
}

resource "aws_instance" "ec2-2" {
  ami           = "ami-0d27e0fb3bac4d724"
  instance_type = "t3.micro"
  subnet_id   = aws_subnet.public_sub_2.id
  key_name = "ec2-keypair"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  associate_public_ip_address = "true"

user_data = <<-EOF
#!/bin/bash
dnf update -y
dnf install -y docker
systemctl enable --now docker
EOF

  tags = {
    Name = "devops_ec2_2"
  }
}


resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.devops_vpc.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
