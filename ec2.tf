# for ec2 we have to create key pair and security group first. Then we can create ec2 instance using that key pair and security group and VPC(virtual private cloud) .
# first create keys through ssh-keygen

#key pair
resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

#VPC
resource "aws_default_vpc" "default" {

}

#security group
resource "aws_security_group" "my_security_group" {
    name        = "Automate Security Group"
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
    ingress{
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
        Name = "Automate Security Group"
    }
    
}


#ec2
resource "aws_instance" "my_ec2_instance" {
    key_name = aws_key_pair.my_key.key_name
    vpc_security_group_ids = [aws_security_group.my_security_group.id ]
    instance_type = "t3.micro"
    ami = "ami-0b6d9d3d33ba97d99"           #ami = amazon machine image (OS) - this is for ubuntu 22.04 LTS in us-east-1 region
    root_block_device{
        volume_size = 15
        volume_type= "gp2"
    }
    tags = {
        Name = "Automate Terra EC2 Instance"
    }
}
