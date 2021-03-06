data "aws_availability_zones" "available" {
  # Retrieve the available zones in the given region
  state = "available"
}

data "aws_ami" "centos" {
  # Retrieve the latest CentOS 7 AMI id
  most_recent = true
  owners      = ["679593333241"]
  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
