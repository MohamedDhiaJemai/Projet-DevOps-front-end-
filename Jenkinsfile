pipeline {
    agent any

    environment {
        FRONTEND_DIR = 'frontend'  // Répertoire du projet frontend
        BACKEND_DIR = 'backend'    // Répertoire du projet backend
        SONARQUBE = 'SonarQube'    // Nom du serveur SonarQube configuré dans Jenkins
        DOCKER_REGISTRY = 'docker-registry.example.com'  // Remplacer par votre registre Docker
        DOCKER_IMAGE_NAME = 'frontend-backend-image'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning repository...'
                checkout scm
            }
        }

        stage('Checkout Backend') {
            steps {
                dir(BACKEND_DIR) {
                    echo 'Cloning backend repository...'
                    checkout scm
                }
            }
        }

        stage('Install Backend Dependencies') {
            steps {
                dir(BACKEND_DIR) {
                    echo 'Installing backend dependencies...'
                    sh 'npm install'
                }
            }
        }

        stage('Run Backend Tests') {
            steps {
                dir(BACKEND_DIR) {
                    echo 'Running tests for backend...'
                    sh 'npm run test -- --coverage --passWithNoTests'  // Ajout de --passWithNoTests pour ne pas échouer sans tests
                }
            }
        }

        stage('SonarQube Analysis Backend') {
            steps {
                script {
                    if (fileExists("${BACKEND_DIR}/sonar-project.properties")) {
                        echo 'Running SonarQube analysis for backend...'
                        withSonarQubeEnv(SONARQUBE) {
                            sh 'mvn sonar:sonar'  // Si vous utilisez Maven pour le backend
                        }
                    } else {
                        echo 'No SonarQube configuration found for backend.'
                    }
                }
            }
        }

        stage('Checkout Frontend') {
            steps {
                dir(FRONTEND_DIR) {
                    echo 'Cloning frontend repository...'
                    checkout scm
                }
            }
        }

        stage('Install Frontend Dependencies') {
            steps {
                dir(FRONTEND_DIR) {
                    echo 'Installing frontend dependencies...'
                    sh 'npm install'
                }
            }
        }

        stage('Run Frontend Tests') {
            steps {
                dir(FRONTEND_DIR) {
                    echo 'Running tests for frontend...'
                    sh 'npm run test -- --coverage --passWithNoTests'  // Ajout de --passWithNoTests pour ne pas échouer sans tests
                }
            }
        }

        stage('SonarQube Analysis Frontend') {
            steps {
                script {
                    if (fileExists("${FRONTEND_DIR}/sonar-project.properties")) {
                        echo 'Running SonarQube analysis for frontend...'
                        withSonarQubeEnv(SONARQUBE) {
                            sh 'mvn sonar:sonar'  // Si vous utilisez Maven pour le frontend
                        }
                    } else {
                        echo 'No SonarQube configuration found for frontend.'
                    }
                }
            }
        }

        stage('Build React App') {
            steps {
                dir(FRONTEND_DIR) {
                    echo 'Building React frontend app...'
                    sh 'npm run build'
                }
            }
        }

        stage('Build Docker Image for Frontend') {
            steps {
                dir(FRONTEND_DIR) {
                    echo 'Building Docker image for frontend...'
                    sh 'docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:frontend .'
                }
            }
        }

        stage('Build Docker Image for Backend') {
            steps {
                dir(BACKEND_DIR) {
                    echo 'Building Docker image for backend...'
                    sh 'docker build -t $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:backend .'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                script {
                    echo 'Pushing Docker images to registry...'
                    sh 'docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:frontend'
                    sh 'docker push $DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:backend'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }

        always {
            cleanWs()
        }
    }
}
