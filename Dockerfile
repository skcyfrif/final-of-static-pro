# Use the official Nginx image
FROM nginx:alpine

# Copy the static website files into the container
COPY . /usr/share/nginx/html

# Create the SSL directory inside the container
RUN mkdir -p /etc/nginx/ssl

# Copy the custom Nginx configuration file into the container
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose the custom ports
EXPOSE 1000 10443

# The default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
