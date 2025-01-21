pipeline {
    agent any

    environment {
        SUDO_PASSWORD = 'your_sudo_password'  // Set this to your sudo password
        APP_DIR = "/var/www/app"
    }

    stages {
        stage('Grant Sudo Permissions to Jenkins') {
            steps {
                script {
                    // Grant Jenkins user passwordless sudo access for specific commands
                    echo 'Granting Jenkins user passwordless sudo access for specific commands...'
                    sh '''
                        echo "jenkins ALL=(ALL) NOPASSWD: /bin/rm, /usr/sbin/nginx, /usr/bin/systemctl, /bin/chmod, /bin/chown" | sudo -S tee -a /etc/sudoers
                    '''
                }
            }
        }

        stage('Clean Old Application Files') {
            steps {
                script {
                    // Remove old application files in the target directory
                    echo 'Removing old application files...'
                    sh "echo ${SUDO_PASSWORD} | sudo -S rm -rf ${APP_DIR}/*"
                }
            }
        }

        // ... other stages
    }
}
