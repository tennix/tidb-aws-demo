output "bastion_public_ip" {
  description = "bastion machine public IP"
  value       = aws_instance.bastion.*.public_ip
}

output "bastion_private_ip" {
  description = "bastion machine private IP"
  value       = aws_instance.bastion.*.private_ip
}

output "sysbench_ip" {
  description = "sysbench machine IP"
  value       = aws_instance.sysbench.*.private_ip
}

output "tidb_ip" {
  description = "tidb machine IP"
  value       = aws_instance.tidb.*.private_ip
}

output "tikv_ip" {
  description = "tikv machine IP"
  value       = aws_instance.tikv.*.private_ip
}
