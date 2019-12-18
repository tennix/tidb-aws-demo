variable "region" {
  type        = string
  description = "aws region"
  default     = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
  default     = "vpc-bc80acc4"
}

variable "allowed_cidrs" {
  type        = list
  description = "allowed cidrs for accessing bastion SSH, Grafana, Prometheus"
  # Please restrict your ingress to only necessary IPs and ports.
  # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
  default = ["0.0.0.0/0"]
}

variable "subnet_cidrs" {
  type        = list
  description = "VPC subnet CIDR list"
}

variable "ssh_key_name" {
  type        = string
  description = "ssh key pair name"
  default     = "oltp-test"
}

variable "cluster_name" {
  type        = string
  description = "AWS resource name prefix"
  default     = "bench-demo"
}

variable "sysbench_count" {
  type        = string
  description = "sysbench instance count"
  default     = 1
}

variable "pd_count" {
  type        = string
  description = "pd instance count"
  default     = 3
}

variable "tidb_count" {
  type        = string
  description = "tidb instance count"
  default     = 3
}

variable "tikv_count" {
  type        = string
  description = "tikv instance count"
  default     = 3
}
