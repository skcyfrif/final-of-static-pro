# Use t66666he official Nginx imageeee
FROM nginx:alpine

# Switch to root userjjj
USER root

# Create the SSL directory inside the container
#RUN mkdir -p /etc/nginx/ssl
#RUN ls -ld /etc/nginx/ssl

# Copy SSL certificates into the container
#COPY fullchain.pem /etc/nginx/ssl/fullchain.pem
#COPY privkey.pem /etc/nginx/ssl/privkey.pem

# Copy static website files into the container
COPY . /usr/share/nginx/html

# Copy custom Nginx configuration into the container
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose the ports you want to use
EXPOSE 1000

# The default command to run Nginx
CMD ["nginx", "-g", "daemon off;"]
