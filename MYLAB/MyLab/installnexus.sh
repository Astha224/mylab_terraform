#!/bin/bash

dnf update -y
dnf install -y java-17-amazon-corretto wget

cd /opt/

# Verified working URL
wget -L https://download.sonatype.com/nexus/3/nexus-unix-x86-64-3.78.0-14.tar.gz

# Exit if download failed
if [ ! -f /opt/nexus-unix-x86-64-3.78.0-14.tar.gz ]; then
  echo "ERROR: Nexus download failed"
  exit 1
fi

# Extract
tar xf /opt/nexus-unix-x86-64-3.78.0-14.tar.gz -C /opt/

# Rename
mv /opt/nexus-3.78.0-14 /opt/nexus3

# Set permissions
chown -R ec2-user:ec2-user /opt/nexus3/ /opt/sonatype-work/

# Set run_as_user
echo 'run_as_user="ec2-user"' > /opt/nexus3/bin/nexus.rc

# Create systemd service
cat <<EOF > /etc/systemd/system/nexus.service
[Unit]
Description=Nexus Repository Manager
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus3/bin/nexus start
ExecStop=/opt/nexus3/bin/nexus stop
User=ec2-user
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable nexus
systemctl start nexus