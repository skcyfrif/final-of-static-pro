pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "cyfdoc/cyfrifprotech" // Replace with your Docker Hub repository
        TAG = "latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Checkout source code
                checkout scm
            }
        }

        stage('Build or Pull Docker Image') {
            steps {
                script {
                    sh '''
                        if docker images -q ${DOCKER_IMAGE}:${TAG} > /dev/null 2>&1; then
                            echo "Image exists locally, pulling the latest version..."
                            docker pull ${DOCKER_IMAGE}:${TAG}
                        else
                            echo "Image does not exist, building locally..."
                            docker build -t ${DOCKER_IMAGE}:${TAG} .
                        fi
                    '''
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'cyfdoc', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push ${DOCKER_IMAGE}:${TAG}
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    sh '''
                        # Check if the container already exists
                        if [ $(docker ps -aq -f name=cyfrifprotech) ]; then
                            echo "Stopping and removing the existing container..."
                            docker stop cyfrifprotech
                            docker rm cyfrifprotech
                        fi
                        
                        echo "Deploying the new container..."
                        docker run -d --name cyfrifprotech -p 1000:1000 \
                            ${DOCKER_IMAGE}:${TAG}
                    '''
                }
            }
        }
    }
}
