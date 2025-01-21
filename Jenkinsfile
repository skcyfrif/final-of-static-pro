pipeline {
    agent any

    environment {
        APP_DIR = "/var/www/app"  // Directory where the app will be deployed
    }

    stages {
        stage('Clean Old Application Files') {
            steps {
                script {
                    // Remove old application files in the target directory
                    echo 'Removing old application files...'
                    sh 'sudo rm -rf ${APP_DIR}/*'
                }
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    // Clone the repository into the app directory
                    echo 'Cloning the repository...'
                    dir(APP_DIR) {
                        checkout scm
                    }
                }
            }
        }

        stage('Set Permissions') {
            steps {
                script {
                    // Set the right permissions for the app directory
                    echo 'Setting permissions for the application files...'
                    sh "sudo chown -R www-data:www-data ${APP_DIR}"
                    sh "sudo chmod -R 755 ${APP_DIR}"
                }
            }
        }

        stage('Reload and Restart Nginx') {
            steps {
                script {
                    echo 'Reloading and restarting Nginx...'
                    sh 'sudo nginx -t'  // Test the Nginx configuration
                    sh 'sudo systemctl reload nginx'  // Reload Nginx
                    sh 'sudo systemctl restart nginx'  // Restart Nginx to ensure changes take effect
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    // Verify that the site is being served over HTTPS
                    try {
                        echo 'Verifying deployment...'
                        sh "curl -I https://cyfrifprotech.com"
                    } catch (Exception e) {
                        error "Deployment verification failed: ${e.message}"
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
