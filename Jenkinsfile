pipeline {
    agent any

    environment {
        APP_DIR = "/var/www/app"
        REPO_URL = "https://github.com/skcyfrif/final-of-static-pro.git"  // Your GitHub repository URL
    }

    stages {
        stage('Prepare Deployment Directory') {
            steps {
                script {
                    echo 'Preparing deployment directory...'

                    // Ensure the application directory exists and clean it
                    sh '''
                        if [ -d "${APP_DIR}" ]; then
                            sudo rm -rf ${APP_DIR}/*
                            echo "Old application files removed successfully."
                        else
                            echo "Directory ${APP_DIR} does not exist. Creating it..."
                            sudo mkdir -p ${APP_DIR}
                        fi
                    '''
                }
            }
        }

        stage('Download Code from GitHub') {
            steps {
                script {
                    echo 'Cloning repository...'

                    // Clone the GitHub repository into the target directory
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

                    // Reload and restart Nginx to serve the updated application
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
