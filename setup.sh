#!/bin/bash

# Update system
apt-get update
apt-get upgrade -y

# Install required packages
apt-get install -y nginx docker.io docker-compose certbot python3-certbot-nginx

# Start and enable Docker
systemctl start docker
systemctl enable docker

# Create necessary directories
mkdir -p /var/www/ghost
cd /var/www/ghost

# Copy configuration files
cp /root/emlog-app/nginx.conf /etc/nginx/sites-available/ghost
cp /root/emlog-app/docker-compose.yaml .

# Enable the site
ln -s /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default  # Remove default site

# Test and reload nginx
nginx -t
systemctl reload nginx

# Start Ghost
docker-compose up -d

# Setup SSL with Let's Encrypt
certbot --nginx -d emlog.app --non-interactive --agree-tos --email your-email@example.com 