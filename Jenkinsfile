pipeline {
    agent any
    
    tools{
        jdk "jdk17"
        maven "mvn3"
    }
    
    environment{
        SCANNER_HOME= tool "sonar"
    }

    stages {
        stage('Clean Ws') {
            steps {
                cleanWs()
            }
        }
        
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/teliVighnesh04/Employee-Management-System-CICD.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        
        stage('File System scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=EMS -Dsonar.projectKey=EMS -Dsonar.java.binaries=."
                }
            }
        }
        
        stage('Download wait-for-it script') {
            steps {
                sh '''
                    wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
                    chmod +x wait-for-it.sh
                '''
            }
        }
        
        stage('Build Docker image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker build -t vighneshteli/ems:latest ."
                    }
                }
            }
        }
        
        stage('Image scan') {
            steps {
                sh "trivy image --format table -o trivy-image-report.html vighneshteli/ems:latest"
            }
        }
        
        stage('Push Docker image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh "docker push vighneshteli/ems:latest"
                    }
                }
            }
        }
        
        stage('Deploy with docker compose') {
            steps {
                sh "docker compose down && docker compose up -d"
            }
        }
    }
}

