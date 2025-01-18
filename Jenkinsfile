pipeline {
    agent any

    environment {
        IMAGE_NAME = "cyfrifprotech/frontend-app"
        TAG = "latest"
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Checkout source code
                checkout scm
            }
        }
       stage('Build Docker Image') {
    steps {
        script {
            // Navigate to the 'cyfrif_pro' directory
            dir('cyfrif_pro') {
                // Check if the Dockerfile exists in the 'cyfrif_pro' directory
                if (!fileExists('Dockerfile')) {
                    error "Dockerfile not found in the 'cyfrif_pro' directory!"
                }

                // Build the Docker image using the Dockerfile in 'cyfrif_pro'
                docker.build("${IMAGE_NAME}:${TAG}", ".")
            }
        }
    }
}

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        docker.image("${IMAGE_NAME}:${TAG}").push()
                    }
                }
            }
        }
        stage('Deploy Container') {
            steps {
                script {
                    // Remove the old container if it exists
                    sh "docker rm -f frontend-app || true"

                    // Run a new container with the updated image
                    sh "docker run -d --name frontend-app -p 5555:80 -p 443:443 ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }
}