pipeline {
    agent any

    stages {
        stage ('Deploy'){
            steps{
                ansiblePlaybook(
                	inventory: '/home/ubuntu/inventory',
                	playbook: 'deploy_app.yml'
                )
            }
        }
    }
}