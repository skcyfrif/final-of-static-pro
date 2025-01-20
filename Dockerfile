# Use the official Nginx image
FROM nginx:alpine

# Copy the static website files into the container
COPY . /usr/share/nginx/html

# Create the SSL directory inside the container
RUN mkdir -p /etc/nginx/ssl

# Copy the custom Nginx configuration file into the container
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy SSL certificates into the container (adjust the source path as needed)
COPY ./fullchain.pem /etc/nginx/ssl/fullchain.pem
COPY ./privkey.pem /etc/nginx/ssl/privkey.pem

# Expose the custom ports
EXPOSE 1000 10443

# The default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]

