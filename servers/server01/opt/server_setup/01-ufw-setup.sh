#!/bin/bash
# UFW firewall configuration
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 86.50.22.88/32 to any port 22 proto tcp
sudo ufw allow from 86.50.22.88/32 to any port 80 proto tcp
sudo ufw allow from 86.50.22.88/32 to any port 443 proto tcp
sudo ufw allow from 193.166.164.0/24 to any port 22 proto tcp
sudo ufw allow from 193.166.164.0/24 to any port 80 proto tcp
sudo ufw allow from 193.166.164.0/24 to any port 443 proto tcp
sudo ufw --force enable
