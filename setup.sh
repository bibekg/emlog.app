#!/bin/bash

# Exit on error
set -e

echo "Starting setup process..."

# Update system
echo "Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required packages
echo "Installing required packages..."
apt-get install -y nginx docker.io docker-compose

# Start and enable Docker
echo "Setting up Docker..."
systemctl start docker
systemctl enable docker

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /var/www/ghost
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# Setup nginx configuration
echo "Setting up nginx configuration..."
cp nginx.conf /etc/nginx/sites-available/ghost
ln -sf /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost
rm -f /etc/nginx/sites-enabled/default

# Test and reload nginx
echo "Testing and reloading nginx..."
nginx -t
systemctl reload nginx

# Copy docker-compose file
echo "Setting up Docker configuration..."
cp docker-compose.yaml /var/www/ghost/

# Start Ghost
echo "Starting Ghost..."
cd /var/www/ghost
docker-compose up -d

echo "Setup completed successfully!"
echo "You can now access Ghost at https://test.emlog.app" 