# Ghost Blog Deployment

This repository contains configuration files for deploying a Ghost blog on a DigitalOcean droplet.

## Prerequisites

- A DigitalOcean droplet with Ubuntu 20.04 or later
- A domain name pointing to your droplet's IP address
- SSH access to your droplet

## Setup Instructions

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/yourusername/emlog-app.git
   ```

2. Copy the files to your DigitalOcean droplet:

   ```bash
   scp -r ./* root@your-droplet-ip:/root/emlog-app/
   ```

3. SSH into your droplet:

   ```bash
   ssh root@your-droplet-ip
   ```

4. Make the setup script executable and run it:

   ```bash
   cd /root/emlog-app
   chmod +x setup.sh
   ./setup.sh
   ```

5. Update the email address in the setup script for SSL certificate notifications.

6. After the setup is complete, visit https://emlog.app to complete the Ghost installation.

## Configuration Files

- `nginx.conf`: Nginx configuration for reverse proxy
- `docker-compose.yaml`: Docker Compose configuration for Ghost
- `setup.sh`: Automated setup script

## Maintenance

To update Ghost:

```bash
cd /var/www/ghost
docker-compose pull
docker-compose up -d
```

To view logs:

```bash
docker-compose logs -f
```

## Backup

The Ghost content is stored in the `content` directory. Regular backups of this directory are recommended.
