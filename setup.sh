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
apt-get install -y nginx docker.io docker-compose certbot python3-certbot-nginx

# Start and enable Docker
echo "Setting up Docker..."
systemctl start docker
systemctl enable docker

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /var/www/ghost
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled

# Copy configuration files
echo "Copying configuration files..."
cp nginx.conf /etc/nginx/sites-available/ghost

# Remove default site if it exists
if [ -f /etc/nginx/sites-enabled/default ]; then
    rm /etc/nginx/sites-enabled/default
fi

# Create symbolic link for ghost site
echo "Setting up Nginx configuration..."
ln -sf /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost

# Test nginx configuration
echo "Testing Nginx configuration..."
nginx -t

# Reload nginx
echo "Reloading Nginx..."
systemctl reload nginx

# Get SSL certificate
echo "Getting SSL certificate..."
certbot --nginx -d test.emlog.app --non-interactive --agree-tos --email ghim.bibek@gmail.com

# Copy docker-compose file
echo "Setting up Docker configuration..."
cp docker-compose.yaml /var/www/ghost/

# Start Ghost
echo "Starting Ghost..."
cd /var/www/ghost
docker-compose up -d

echo "Setup completed successfully!"
echo "You can now access Ghost at http://localhost" 