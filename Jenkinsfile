pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "cyfdoc/cyfrifprotech" // Use your Docker Hub username/repository
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
				sh '''
                docker images -q ${DOCKER_IMAGE}:${TAG} && docker pull ${DOCKER_IMAGE}:${TAG} || docker build -t ${DOCKER_IMAGE}:${TAG} .
                '''
			}
		}

        stage('Push to Docker Hub') {
            steps {
                echo 'Pushing Docker Image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'cyfdoc', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Check if a container with the specified name exists, then remove it
					sh '''
					if [ $(docker ps -aq -f name=cyfrifprotech) ]; then
						docker stop cyfrifprotech
						docker rm cyfrifprotech
					fi
					docker run -d --name cyfrifprotech -p 1000:1000 ${DOCKER_IMAGE}:${TAG}
					'''
                }
            }
        }
    }
}