# Ensure you're running as root
USER root

# Create the SSL directory
RUN mkdir -p /etc/nginx/ssl

# Copy SSL certificates into the container
COPY ./fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY ./privkey.pem /etc/nginx/ssl/privkey.pem

# Expose necessary ports
EXPOSE 1000 10443

# Copy static website files and nginx configuration
COPY . /usr/share/nginx/html
COPY default.conf /etc/nginx/conf.d/default.conf

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
