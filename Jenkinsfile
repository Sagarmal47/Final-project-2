pipeline {
    agent any
    environment {
        git_url = "https://github.com/Sagarmal47/Final-project-2.git"
        AWS_ACCESS_KEY_ID = credentials('aws_key')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret')
        AWS_DEFAULT_REGION = 'ap-south-1'
    }
    stages {
        stage("Git Checkout ") {
            steps {
                sh '''
                if [ -d Final-project-2 ]; then
                  echo "Folder Already Present No need to checkout"
                else
                  git clone ${env.git_url}
                fi
                '''
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
        stage("Terraform Destroy") {
            steps {
                sh "pwd && ls -lrth "
                dir("terraform/"){
                sh "terraform destroy --auto-approve"
                }
            }
        }
    }
}
