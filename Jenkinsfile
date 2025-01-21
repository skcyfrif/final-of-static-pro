pipeline {
    agent any

    environment {
        APP_DIR = "/var/www/myapp"
        REPO_URL = "https://github.com/skcyfrif/final-of-static-pro.git"
        CERT_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/fullchain.pem"
        KEY_PATH = "/etc/letsencrypt/live/cyfrifprotech.com/privkey.pem"
    }

    stages {
        stage('Check SSL Certificates') {
            steps {
                script {
                    echo 'Checking SSL certificates...'

                    def certExists = sh(script: "test -f ${CERT_PATH} && echo 'found' || echo 'not found'", returnStdout: true).trim()
                    def keyExists = sh(script: "test -f ${KEY_PATH} && echo 'found' || echo 'not found'", returnStdout: true).trim()

                    if (certExists == 'not found') {
                        error "Certificate not found at ${CERT_PATH}. Please ensure it exists."
                    } else {
                        echo "Certificate found at ${CERT_PATH}."
                    }

                    if (keyExists == 'not found') {
                        error "Private key not found at ${KEY_PATH}. Please ensure it exists."
                    } else {
                        echo "Private key found at ${KEY_PATH}."
                    }
                }
            }
        }

        stage('Prepare Deployment Directory') {
            steps {
                script {
                    echo 'Preparing deployment directory....--........'

                    // Ensure the application directory is fully cleared
                    sh '''
                        if [ -d "${APP_DIR}" ]; then
                            sudo rm -rf ${APP_DIR}
                            echo "Old application directory removed."
                        fi
                        sudo mkdir -p ${APP_DIR}
                        echo "New application directory created."
                    '''
                }
            }
        }

        stage('Download Code from GitHub') {
            steps {
                script {
                    echo 'Cloning repository........'

                    // Clone the GitHub repository into the cleaned directory
                    sh '''
                        sudo git clone ${REPO_URL} ${APP_DIR}
                        echo "Repository cloned successfully."
                    '''
                }
            }
        }

        stage('Reload and Restart Nginx') {
            steps {
                script {
                    echo 'Reloading and restarting Nginx...'

                    // Reload and restart Nginx
                    sh '''
                        sudo nginx -t
                        sudo systemctl reload nginx
                        sudo systemctl restart nginx
                        echo "Nginx reloaded and restarted successfully."
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment pipeline completed successfully.'
        }
        failure {
            echo 'Deployment pipeline failed. Please check the logs for more details.'
        }
    }
}
