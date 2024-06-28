pipeline {
    agent { label 'docker' }

    environment {
        DOCKER_IMAGE = 'sparkle-java'
        DOCKER_IMAGE_TAG = "${BUILD_NUMBER}"
        DOCKER_IMAGE_NAME = "bhargavilakamsani/${DOCKER_IMAGE}:${DOCKER_IMAGE_TAG}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/master']],
                    extensions: [],
                    userRemoteConfigs: [[url: 'https://github.com/Bhargavi-lakamsani/sparkjava-war-example.git']]
                )
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE_NAME} ."
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
            sshagent(credentials: ['k8s']) {
                sh """
                scp -o StrictHostKeyChecking=no deployment.yaml service.yaml ${REMOTE_HOST}:/home/ubuntu
                ssh ${REMOTE_HOST} "kubectl apply -f /home/ubuntu/deployment.yaml"
                ssh ${REMOTE_HOST} "kubectl apply -f /home/ubuntu/service.yaml"
                """
                        }
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
