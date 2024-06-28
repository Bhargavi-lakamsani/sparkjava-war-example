pipeline {
    agent { label 'docker' }

    environment {
        DOCKER_IMAGE = 'sparkle-java'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE_NAME = "bhargavilakamsani/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}"
        KUBECONFIG = '/var/snap/microk8s/current/credentials/client.config'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                script {
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}", '.')
                    dockerImage.inside {
                        sh 'mvn clean install'
                    }
                }
            }
        }

        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'bhargavi-docker', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE_NAME
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sshagent(['k8s']) {
                        sh '''
                        scp -o StrictHostKeyChecking=no deployment.yaml service.yaml ubuntu@52.66.201.175:/home/ubuntu
                        ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@52.66.201.175 "export KUBECONFIG=/var/snap/microk8s/current/credentials/client.config && kubectl apply -f /home/ubuntu/deployment.yaml -f /home/ubuntu/service.yaml"
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
