pipeline {
    agent any
    environment {
        git_url = "https://github.com/Sagarmal47/Final-project-2.git"
        AWS_ACCESS_KEY_ID = credentials('access')
        AWS_SECRET_ACCESS_KEY = credentials('secret')
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    stages {
        stage("Git Checkout ") {
            steps {
                sh "git clone ${env.git_url}"
            }
        }
        stage("Terraform Infra Build") {
        steps {
            dir("terraform/") {
                sh "terraform init"
                sh "terraform apply --auto-approve"
            }
        }
    }
    }
    
}

