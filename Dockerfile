# Use a lightweight web server
FROM nginx:alpine

# Install Certbot, Nginx, and cron (using dcron for Alpine)
RUN apk add --no-cache certbot certbot-nginx nginx dcron

# Copy all static files from the project root to the Nginx default public directory
COPY ./ /usr/share/nginx/html

# Copy the custom Nginx configuration file
COPY ./nginx.conf /etc/nginx/nginx.conf

# Copy the script to generate SSL certificates if not present
COPY ./init-ssl.sh /init-ssl.sh
RUN chmod +x /init-ssl.sh

# Copy the cron job to renew SSL certificates
COPY ./certbot-renew-cron /etc/cron.d/certbot-renew

# Expose HTTP and HTTPS ports
EXPOSE 80 443

# Run the initialization script to ensure SSL certificates are generated, and start cron and nginx
CMD ["/init-ssl.sh"]