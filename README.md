# Demo for deploying TiDB Cluster on AWS

## Provisioning AWS resources

A production TiDB Cluster requires several machines, it's better to use [Terraform](https://www.terraform.io) to provision AWS resources instead of managing them on cloud console.

Make sure terraform (>=0.12.0) is installed on local machine

1. Clone this repo: `git clone https://github.com/tennix/tidb-aws-demo`
2. Initialize terraform: `cd tidb-aws-demo && terraform init`
3. Customize the variables in `variables.tf`
3. Check provision plan: `terraform plan`
4. Applying plan: `terraform apply`

After the above steps, if executed successfully, the required AWS resources will be created and the EC2 instances IP lists are printed.

You can copy the SSH key into bastion machine by: `scp -i /path/to/ssh-key.pem /path/to/ssh-key.pem centos@<bastion-public-ip>:/home/centos/`

Then ssh into the bastion to deploy TiDB cluster using [TiDB Ansible](https://github.com/pingcap/tidb-ansible).
