#!/bin/bash
# For Amazon Linux 2023

dnf update -y
dnf install -y python3 python3-pip openssl

# Install ansible system-wide
pip3 install ansible

# Symlink so ansible is available for all users
ln -sf /usr/local/bin/ansible /usr/bin/ansible

# Add ansible admin user
useradd ansibleadmin
echo "ansibleansible" | passwd --stdin ansibleadmin

# Passwordless sudo
echo 'ansibleadmin  ALL=(ALL)  NOPASSWD: ALL' | tee -a /etc/sudoers
echo 'ec2-user      ALL=(ALL)  NOPASSWD: ALL' | tee -a /etc/sudoers

# Enable password auth for SSH
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
systemctl restart sshd