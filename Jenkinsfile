pipeline {
    agent any
    environment {
        FRONTEND_DIR = 'react-crud-web-api-master'  // Répertoire du projet React
        IMAGE_NAME = 'my-react-frontend-image'  // Nom de l'image Docker du front-end
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Récupérer le code source depuis GitHub
            }
        }
        stage('Install Dependencies') {
            steps {
                dir("${env.FRONTEND_DIR}") {
                    script {
                        echo 'Installing dependencies for front-end...'
                        sh 'npm install'  // Installer les dépendances via npm
                    }
                }
            }
        }
        stage('Build React App') {
            steps {
                dir("${env.FRONTEND_DIR}") {
                    script {
                        echo 'Building the React application...'
                        sh 'npm run build'  // Construire l'application React pour la production
                    }
                }
            }
        }
        stage('Build Docker Image for Front-end') {
            steps {
                script {
                    echo 'Building Docker image for front-end...'
                    sh 'docker build -t ${env.IMAGE_NAME} ${env.FRONTEND_DIR}'  // Construire l'image Docker
                }
            }
        }
    }
    post {
        success {
            echo 'Front-end build and Docker image creation successful!'
        }
        failure {
            echo 'Front-end build or Docker image creation failed!'
        }
    }
}

