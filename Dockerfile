# Use the official Nginx image
FROM nginx:alpine

# Copy the static website files into the container
COPY . /usr/share/nginx/html

# (Ensure you have the correct path to your Certbot-generated certs)
COPY ./etc/letsencrypt/live/cyfrifprotech.com/fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY ./etc/letsencrypt/live/cyfrifprotech.com/privkey.pem /etc/nginx/ssl/privkey.pem


# Copy the custom Nginx configuration file into the container
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose the port you want to use
EXPOSE 1000

# The default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]