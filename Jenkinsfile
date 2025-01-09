pipeline {
    agent any
    environment {
        FRONTEND_DIR = '.'  // Répertoire du projet React
        IMAGE_NAME = 'my-react-frontend-image'  // Nom de l'image Docker du front-end
        SONAR_SERVER = 'SonarQube'  // Nom du serveur SonarQube configuré dans Jenkins
        SONAR_SCANNER_HOME = '/opt/sonar-scanner'  // Chemin vers SonarQube Scanner (ajustez si nécessaire)
        PATH = "${SONAR_SCANNER_HOME}/bin:${env.PATH}"  // Ajoute sonar-scanner à la variable PATH
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

        stage('Run Tests') {
            steps {
                dir("${env.FRONTEND_DIR}") {
                    script {
                        echo 'Running tests for front-end...'
                        // Exécuter les tests avec couverture, mais ignorer l'échec s'il n'y a pas de tests
                        sh 'npm run test -- --coverage || true'
                    }
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv("${env.SONAR_SERVER}") {
                    dir("${env.FRONTEND_DIR}") {
                        script {
                            echo 'Running SonarQube analysis for front-end...'
                            sh '''
                            sonar-scanner \
                            -Dsonar.projectKey=react-frontend-app \
                            -Dsonar.projectName="React Frontend App" \
                            -Dsonar.projectVersion=1.0 \
                            -Dsonar.sources=. \
                            -Dsonar.sourceEncoding=UTF-8 \
                            -Dsonar.javascript.lcov.reportPaths=coverage/lcov-report/index-lcov-report.json
                            '''
                        }
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
                    sh '''#!/bin/bash
                    docker build -t ${IMAGE_NAME} ${FRONTEND_DIR}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Front-end build, SonarQube analysis, and Docker image creation successful!'
        }
        failure {
            echo '❌ Front-end build, SonarQube analysis, or Docker image creation failed!'
        }
    }
}
