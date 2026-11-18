#!/bin/bash
# Host firewall for SRTL-Leg-Server (Phase 1, CIS firewall checks).
# Run with a second SSH session open. The SSH allow rule goes first to avoid a lockout.

# SSH only from the admin laptop
sudo ufw allow from 192.168.56.1 to any port 22 proto tcp comment 'SSH from admin laptop'

# Loopback rules (CIS 35623)
sudo ufw allow in on lo
sudo ufw allow out on lo
sudo ufw deny in from 127.0.0.0/8
sudo ufw deny in from ::1

# Only the outbound traffic the server needs
sudo ufw allow out 53 comment 'DNS'
sudo ufw allow out 123/udp comment 'NTP time sync'
sudo ufw allow out 80/tcp comment 'apt updates'
sudo ufw allow out 443/tcp comment 'apt updates HTTPS'
sudo ufw allow out 67/udp comment 'DHCP renew on NAT'
sudo ufw allow out to 192.168.56.10 port 1514:1515 proto tcp comment 'Wazuh agent'

# Default deny in every direction
sudo ufw default deny incoming
sudo ufw default deny outgoing
sudo ufw default deny routed

# Keep ufw as the only firewall service (CIS 35619), review, then enable
sudo systemctl mask nftables.service
sudo ufw show added
sudo ufw enable
sudo ufw status verbose
