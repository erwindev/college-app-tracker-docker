pipeline {
    agent any

    stages {
        stage ('Compile'){
            steps{
                sh 'ansible-playbook -i inventory deploy_app.yml'
            }
        }
    }
}