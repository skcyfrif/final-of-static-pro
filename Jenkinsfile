pipeline {
    agent any

    environment {
        APP_DIR = "/var/www/app"
        SSL_CERT_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/fullchain.pem"
        SSL_KEY_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/privkey.pem"
        NGINX_SITE_CONFIG = "/etc/nginx/sites-available/cyfrifprotech.com"
        NGINX_ENABLED_SITE = "/etc/nginx/sites-enabled/cyfrifprotech.com"
    }

    stages {
        stage('Check Nginx Installation') {
            steps {
                script {
                    def nginxInstalled = sh(script: 'which nginx', returnStatus: true) == 0
                    if (!nginxInstalled) {
                        echo 'Nginx not found. Installing...'
                        sh 'sudo apt-get update -y && sudo apt-get install -y nginx'
                    } else {
                        echo 'Nginx is already installed.'
                    }
                }
            }
        }

        stage('Check SSL Certificates') {
            steps {
                script {
                    // Check the existence of SSL certificates by running ls directly
                    def certExists = sh(script: "ls -l ${SSL_CERT_PATH} && ls -l ${SSL_KEY_PATH}", returnStatus: true) == 0
                    if (!certExists) {
                        echo 'SSL certificates not found. Installing Certbot and generating certificates...'
                        // Install Certbot and generate certificates
                        sh 'sudo apt-get install -y certbot python3-certbot-nginx'
                        sh "sudo certbot --nginx -d cyfrifprotech.com -d www.cyfrifprotech.com --agree-tos --non-interactive --email admin@cyfrifprotech.com"
                    } else {
                        echo 'SSL certificates already exist.'
                        // Log the files in the directory to ensure certificates are found
                        sh "ls -l /etc/letsencrypt/live/cyfrifprotech.com"
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    sh "sudo mkdir -p ${APP_DIR}"
                    dir(APP_DIR) {
                        checkout scm
                    }
                }
            }
        }

        stage('Set Permissions') {
            steps {
                script {
                    sh "sudo chown -R www-data:www-data ${APP_DIR}"
                    sh "sudo chmod -R 755 ${APP_DIR}"
                }
            }
        }

        stage('Configure Nginx for SSL') {
            steps {
                script {
                    if (!fileExists(NGINX_SITE_CONFIG)) {
                        echo 'Creating Nginx configuration...'
                        sh """
                            sudo bash -c 'cat > ${NGINX_SITE_CONFIG} <<EOF
                            server {
                                listen 443 ssl;
                                server_name cyfrifprotech.com www.cyfrifprotech.com;

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
                                server_name cyfrifprotech.com www.cyfrifprotech.com;

                                return 301 https://\$host\$request_uri;
                            }
                            EOF'
                        """
                        sh "sudo ln -s ${NGINX_SITE_CONFIG} ${NGINX_ENABLED_SITE} || true"
                        sh "sudo nginx -t"
                        sh "sudo systemctl reload nginx"
                    } else {
                        echo 'Nginx configuration already exists.'
                    }
                }
            }
        }

        stage('Verify SSL Deployment') {
            steps {
                script {
                    try {
                        sh "curl -I https://cyfrifprotech.com"
                    } catch (Exception e) {
                        error "SSL deployment verification failed: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}

