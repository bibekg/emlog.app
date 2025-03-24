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
apt-get install -y nginx docker.io docker-compose openssl

# Start and enable Docker
echo "Setting up Docker..."
systemctl start docker
systemctl enable docker

# Create necessary directories
echo "Creating necessary directories..."
mkdir -p /var/www/ghost
mkdir -p /etc/nginx/sites-available
mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
echo "Generating self-signed SSL certificate..."
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/self-signed.key \
    -out /etc/nginx/ssl/self-signed.crt \
    -subj "/C=US/ST=CA/L=SanFrancisco/O=Emlog/CN=test.emlog.app"

# Setup nginx configuration
echo "Setting up nginx configuration..."
cp nginx.conf /etc/nginx/sites-available/ghost
ln -sf /etc/nginx/sites-available/ghost /etc/nginx/sites-enabled/ghost
rm -f /etc/nginx/sites-enabled/default

# Setup Cloudflare IP ranges
echo "Setting up Cloudflare IP ranges..."
curl -s https://www.cloudflare.com/ips-v4 | sed 's/^/set_real_ip_from /;s/$/;/' > /etc/nginx/cloudflare.conf

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

# Clean up any existing containers and volumes
echo "Cleaning up existing containers and volumes..."
docker-compose down -v || true

# Create volumes first
echo "Creating Docker volumes..."
docker volume create ghost-content || true
docker volume create ghost-config || true

# Start Ghost
echo "Starting Ghost container..."
docker-compose up -d

echo "Setup completed successfully!"
echo "You can now access Ghost at https://test.emlog.app" 