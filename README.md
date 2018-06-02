# Demo for deploying TiDB Cluster on AWS

## Provisioning AWS resources

A production TiDB Cluster requires several machines, it's better to use [Terraform](https://www.terraform.io) to provision AWS resources instead of managing them on cloud console.

Make sure terraform v0.11.7 is installed on local machine

1. Clone this repo: git clone https://github.com/tennix/tidb-aws-demo
2. Initialize terraform: cd tidb-aws-demo && terraform init
3. Check provision plan: terraform plan
4. Applying plan: terraform apply

After the above steps, if executed successfully, the required AWS resources will be created. Bastion machine IP will be printed on the screen which will be used in the next section. And an inventory.ini will be created, this file is used for [tidb-ansible](https://github.com/pingcap/tidb-ansible) to deploy TiDB cluster.

## Deploying TiDB Cluster

Copy SSH key into bastion machine: scp -i keys/private.pem keys/private.pem ec2-user@BASTION_IP:/home/ec2-user/

Copy inventory.ini into bastion machine: scp inventory.ini ec2-user@BASTION_IP:/home/ec2-user/

SSH into bastion machine: ssh -i keys/private.pem ec2-user@BASTION_IP

Config ssh key: mkdir -p ~/.ssh && mv ~/private.pem ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa

Install required packages on bastion machine:

```
sudo yum install -y git python-pip curl mysql
git clone https://github.com/pingcap/tidb-ansible
cd tidb-ansible
sudo pip install -r requirements.txt
```
Specify SSH configuration in ansible.cfg: `ssh_args = -i /home/ec2-user/.ssh/id_rsa -C -o ControlMaster=auto -o ControlPersist=60s`

After the above steps are done, following tidb-ansible documentation to deploy TiDB cluster

```
ansible-playbook local_prepare.yml
ansible-playbook bootstrap.yml
ansible-playbook deploy.yml
ansible-playbook start.yml
```
