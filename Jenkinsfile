pipeline {
    agent any

    environment {
        DOMAIN_NAME = "cyfrifprotech.com"
        REPO_URL = "https://github.com/skcyfrif/final-of-static-pro.git"
        APP_DIR = "/var/www/app"  // Directory where the app will be deployed
        SSL_CERT_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/fullchain.pem"  // Path to your SSL certificate
        SSL_KEY_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/privkey.pem"  // Path to your SSL private key
        NGINX_SITE_CONFIG = "/etc/nginx/sites-available/cyfrifprotech.com"  // Path to Nginx config
        NGINX_ENABLED_SITE = "/etc/nginx/sites-enabled/cyfrifprotech.com"  // Path to the enabled site
    }

    stages {
        stage('Check Nginx Installation') {
            steps {
                script {
                    // Check if Nginx is installed
                    def nginxInstalled = sh(script: 'which nginx', returnStatus: true) == 0
                    if (!nginxInstalled) {
                        // If Nginx is not installed, install it
                        echo 'Nginx not found. Installing Nginx...'
                        sh 'sudo apt-get update -y'
                        sh 'sudo apt-get install -y nginx'
                    } else {
                        echo 'Nginx is already installed.'
                    }
                }
            }
        }

        stage('Check SSL Certificates') {
            steps {
                script {
                    // Check if SSL certificates exist
                    def sslCertExists = fileExists(SSL_CERT_PATH) && fileExists(SSL_KEY_PATH)
                    if (!sslCertExists) {
                        // If SSL certificates are not found, use Certbot to install them
                        echo 'SSL certificates not found. Installing Certbot and generating certificates...'
                        sh 'sudo apt-get install -y certbot python3-certbot-nginx'
                        sh 'sudo certbot --nginx -d www.cyfrifprotech.com -d cyfrifprotech.com --agree-tos --non-interactive --email your-email@example.com'
                    } else {
                        echo 'SSL certificates already installed.'
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                // Clone the repository to get the application code
                git "${REPO_URL}"
            }
        }

        stage('Deploy Application') {
            steps {
                script {
                    // Copy the application files to the web root directory
                    sh 'sudo cp -r * /var/www/app'
                    
                    // Set the right permissions for the web directory
                    sh 'sudo chown -R www-data:www-data /var/www/app'
                }
            }
        }

        stage('Configure Nginx for SSL') {
            when {
                expression {
                    // Check if Nginx config already exists for this site
                    return !fileExists(NGINX_SITE_CONFIG) || !fileExists(NGINX_ENABLED_SITE)
                }
            }
            steps {
                script {
                    // Create an Nginx configuration file for the domain to use SSL
                    echo 'Creating Nginx configuration for SSL...'
                    sh """
                        sudo bash -c 'cat > ${NGINX_SITE_CONFIG} <<EOF
                        server {
                            listen 443 ssl;
                            server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};

                            location / {
                                root ${APP_DIR};
                                index index.html;
                                try_files \$uri \$uri/ =404;
                            }

                            ssl_certificate ${SSL_CERT_PATH};
                            ssl_certificate_key ${SSL_KEY_PATH};
                            include /etc/letsencrypt/options-ssl-nginx.conf;
                            ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
                        }

                        server {
                            listen 80;
                            server_name ${DOMAIN_NAME} www.${DOMAIN_NAME};

                            return 301 https://\$host\$request_uri;
                        }
                        EOF'
                    """
                    
                    // Enable the site by creating a symbolic link to sites-enabled
                    sh "sudo ln -s ${NGINX_SITE_CONFIG} ${NGINX_ENABLED_SITE}"
                    
                    // Test the Nginx configuration
                    sh "sudo nginx -t"
                    
                    // Reload Nginx to apply the new configuration
                    sh "sudo systemctl reload nginx"
                }
            }
        }

        stage('Verify SSL Deployment') {
            steps {
                script {
                    // Verify that the site is correctly served over HTTPS
                    sh 'curl -I https://www.cyfrifprotech.com'
                }
            }
        }
    }
}
