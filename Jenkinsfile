pipeline {
    agent any

    stages {
        stage('Prepare install') {
            steps {
                sh 'git clone https://github.com/streetstorm/jenkins_dz/'
                sh 'chmod u+x jenkins_dz/time_5sec.sh'
                sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"'
                sh 'chmod u+x ./kubectl'
                sh './kubectl get pods'
            }
        }
        stage('Deploy') {
            steps {
                sh 'jenkins_dz/time_5sec.sh'
            }
        }
        stage('Clean') {
            steps {
                sh 'rm -rf jenkins_dz'
            }
        }
    }
}
