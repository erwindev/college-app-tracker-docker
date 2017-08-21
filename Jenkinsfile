pipeline {
    agent any

    stages {
        stage ('Deploy'){
            steps{
                sh 'ansible-playbook -i inventory deploy_app.yml'
            }
        }
    }
}