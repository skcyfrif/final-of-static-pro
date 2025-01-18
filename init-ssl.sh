#!/bin/sh

# Set domain and email for Let's Encrypt
DOMAIN="cyfrifprotech.com"
EMAIL="tech.ho@cyfrif.com"  # Replace with your email for notifications

# Check if SSL certificates already exist
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ] || [ ! -f /etc/letsencrypt/live/$DOMAIN/privkey.pem ]; then
    echo "SSL certificates not found. Generating new certificates with Certbot..."

    # Use Certbot to obtain SSL certificates
    certbot certonly --webroot -w /usr/share/nginx/html -d $DOMAIN -d www.$DOMAIN --email $EMAIL --agree-tos --no-eff-email --quiet

    echo "SSL certificates generated successfully."
else
    echo "SSL certificates already exist. Skipping generation."
fi

# Start the cron job for SSL certificate renewal
# Make sure the cron job to renew certificates is already set up in the Docker image
crond

# Start Nginx in the foreground
nginx -g "daemon off;"
