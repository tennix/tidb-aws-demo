provider "aws" {
  region = var.region
}

resource "aws_security_group" "tidb_external" {
  name        = "${var.cluster_name}-tidb-external"
  description = "Allow TiDB external traffic (SSH, Grafana, Prometheus)"
  vpc_id      = var.vpc_id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # Grafana
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # Prometheus
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tidb_internal" {
  name        = "${var.cluster_name}-tidb-internal"
  description = "Allow TiDB internal traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  instance_type               = "c5.xlarge"
  ami                         = data.aws_ami.centos.id
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.tidb_internal.id, aws_security_group.tidb_external.id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true
  tags = {
    Name = "${var.cluster_name}-bastion"
  }
  root_block_device {
    volume_size = 100
  }
}

resource "aws_instance" "sysbench" {
  instance_type          = "c5.4xlarge"
  ami                    = data.aws_ami.centos.id
  availability_zone      = "${data.aws_availability_zones.available.names[count.index % 3]}"
  vpc_security_group_ids = [aws_security_group.tidb_internal.id]
  key_name               = var.ssh_key_name
  count                  = var.sysbench_count
  tags = {
    Name = "${var.cluster_name}-sysbench-${count.index}"
  }
}

resource "aws_instance" "pd" {
  instance_type          = "m5.xlarge"
  ami                    = data.aws_ami.centos.id
  availability_zone      = "${data.aws_availability_zones.available.names[count.index % 3]}"
  vpc_security_group_ids = [aws_security_group.tidb_internal.id]
  key_name               = var.ssh_key_name
  count                  = var.pd_count
  tags = {
    Name = "${var.cluster_name}-pd-${count.index}"
  }
}

resource "aws_instance" "tidb" {
  instance_type          = "c5.4xlarge"
  ami                    = data.aws_ami.centos.id
  availability_zone      = "${data.aws_availability_zones.available.names[count.index % 3]}"
  vpc_security_group_ids = [aws_security_group.tidb_internal.id]
  key_name               = var.ssh_key_name
  count                  = var.tidb_count
  tags = {
    Name = "${var.cluster_name}-tidb-${count.index}"
  }
}

resource "aws_instance" "tikv" {
  instance_type          = "c5d.4xlarge"
  ami                    = data.aws_ami.centos.id
  availability_zone      = "${data.aws_availability_zones.available.names[count.index % 3]}"
  vpc_security_group_ids = [aws_security_group.tidb_internal.id]
  key_name               = var.ssh_key_name
  count                  = var.tikv_count
  tags = {
    Name = "${var.cluster_name}-tikv-${count.index}"
  }
}
