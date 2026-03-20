#!/bin/bash

# Add ansibleadmin user
useradd ansibleadmin
# Set password for ansibleadmin
echo "ansibleansible" | passwd --stdin ansibleadmin
# Set ansibleadmin as sudoers
echo 'ansibleadmin  ALL=(ALL)  NOPASSWD: ALL' | tee -a /etc/sudoers
# Set ec2-user as sudoers
echo 'ec2-user      ALL=(ALL)  NOPASSWD: ALL' | tee -a /etc/sudoers

# Enable SSH password authentication
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd

# Install Docker
# Update packages
dnf update -y
# Install Docker (AL2023 uses dnf, not amazon-linux-extras)
dnf install -y docker
# Start Docker service
systemctl start docker
# Enable Docker to start on boot
systemctl enable docker
# Add ansibleadmin to docker group
usermod -a -G docker ansibleadmin

# Install python3 and docker SDK (docker-py is deprecated, use docker package)
dnf install -y python3-pip
pip3 install docker