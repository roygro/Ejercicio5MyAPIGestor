pipeline {
    agent any

    tools {
        jdk 'jdk21'
        maven 'maven'
    }

    stages {
        stage('Compilar') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Pruebas y JaCoCo') {
            steps {
                sh 'mvn test jacoco:report'
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'mvn sonar:sonar -Dsonar.projectKey=MicroservicioBack -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml'
                }
            }
        }
    }
}
