pipeline {
    agent any
    environment {
        BACKEND_DIR = '.'  // Répertoire du projet Node.js
        FRONTEND_DIR = '.'  // Répertoire du projet React
        IMAGE_NAME = 'my-react-frontend-image'  // Nom de l'image Docker du front-end
        SONAR_SERVER = 'SonarQube'  // Nom du serveur SonarQube configuré dans Jenkins
        SONAR_SCANNER_HOME = '/opt/sonar-scanner'  // Chemin vers SonarQube Scanner (mettez le chemin exact)
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"  // Ajoute sonar-scanner à la variable PATH
    }
    stages {
        // Back-end stages
        stage('Checkout Backend') {
            steps {
                checkout scm  // Récupérer le code source depuis GitHub pour le back-end
            }
        }
        
        stage('Install Backend Dependencies') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Installing dependencies for back-end...'
                        sh 'npm install'
                    }
                }
            }
        }
        
        stage('Run Backend Tests') {
            steps {
                dir("${env.BACKEND_DIR}") {
                    script {
                        echo 'Running tests for back-end...'
                        sh 'npm run test -- --coverage'
                    }
                }
            }
        }

        stage('SonarQube Analysis Backend') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    dir("${env.BACKEND_DIR}") {
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=node-backend-app \
                        -Dsonar.projectName="Node Backend App" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info
                        '''
                    }
                }
            }
        }

        stage('Quality Gate Backend') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        // Front-end stages
        stage('Checkout Frontend') {
            steps {
                checkout scm  // Récupérer le code source depuis GitHub pour le front-end
            }
        }

        stage('Install Frontend Dependencies') {
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

        stage('SonarQube Analysis Frontend') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    dir("${env.FRONTEND_DIR}") {
                        sh '''
                        sonar-scanner \
                        -Dsonar.projectKey=react-frontend-app \
                        -Dsonar.projectName="React Frontend App" \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=. \
                        -Dsonar.sourceEncoding=UTF-8 \
                        -Dsonar.javascript.lcov.reportPaths=coverage/lcov-info
                        '''
                    }
                }
            }
        }

        stage('Quality Gate Frontend') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        
        stage('Build Docker Image for Front-end') {
            steps {
                script {
                    echo 'Building Docker image for front-end...'
                    sh '''#!/bin/bash
                    docker build -t ${IMAGE_NAME} ${FRONTEND_DIR}
                    '''
                }
            }
        }
    }
    post {
        success {
            echo '✅ Front-end and back-end build, SonarQube analysis, and Docker image creation/push successful!'
        }
        failure {
            echo '❌ Front-end and back-end build, SonarQube analysis, or Docker image creation/push failed!'
        }
    }
}
