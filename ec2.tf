# for ec2 we have to create key pair and security group first. Then we can create ec2 instance using that key pair and security group and VPC(virtual private cloud) .
# first create keys through ssh-keygen

#key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
  tags = {
    Name = "${var.environment}-terra-key-ec2"
  }
}

#VPC
resource "aws_default_vpc" "default" {

}

#security group
resource "aws_security_group" "my_security_group" {
  name        = "${var.environment} Automate Security Group"
  description = "Terraform security group"
  vpc_id      = aws_default_vpc.default.id #this is called interpolation/Object-Notation in which we inherit id of our vpc named "default"

  #inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from anywhere"

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP access from anywhere"
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask app"
  }



  #outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic / All access"

  }

  tags = {
    Name = "${var.environment}-Automate Security Group"
  }

}


#ec2n
resource "aws_instance" "my_ec2_instance" {

    #we use count=2 to create 2 ec2 instances. If you want to create three ec2 instances then you can use count=3. This is called "count" meta-argument in terraform.
  count = 2

  key_name               = aws_key_pair.my_key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]
  instance_type          = var.ec2_instance_type
  ami                    = var.aws_ec2_ami #ami = amazon machine image (OS) - this is for ubuntu 22.04 LTS in us-east-1 region

  //user_data allows you to run shell script at startup
  user_data = file("install_nginx.sh") #this is a bash script which will be executed when ec2 instance is created. This script will install nginx web server and create a index.html file in /var/www/html directory.

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = var.ec2_volume_type
  }
  tags = {
    Name = "${var.environment}-Automate Terra EC2 Instance-${count.index + 1}"
    environment = var.environment
  }
}

