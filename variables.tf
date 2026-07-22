variable "ec2_instance_type" {
  default = "t3.micro"
  type    = string

}

variable "ec2_root_storage_size" {
  default = 15
  type    = number
}

variable "aws_ec2_ami" {
  default = "ami-0b6d9d3d33ba97d99"
  type    = string
}

variable "ec2_volume_type" {
  default = "gp2"
  type    = string
}

variable "environment" {
  default = "prd"
  type    = string
}