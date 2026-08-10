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
                
                sh """
                if [ -d "Final-project-2" ]; then
                  echo "Folder Already Present No need to checkout"
                else
                  git clone ${env.git_url}
                fi
                """
            }
        }
        
        stage('Confirm Teardown') {
            steps {
                script {
                    timeout(time: 10, unit: 'MINUTES') {
                        def userChoice = input(
                            id: 'DestroyPrompt',
                            message: 'Select action for infrastructure:',
                            ok: 'Submit',
                            parameters: [
                                choice(
                                    name: 'ACTION', 
                                    choices: ['Skip', 'Destroy'], 
                                    description: 'Choose whether to tear down resources or keep them running.'
                                )
                            ]
                        )

                        if (userChoice == 'Destroy') {
                            echo 'User selected Destroy. Executing teardown...'
                            sh 'terraform destroy -auto-approve'
                            
                        } else {
                            echo 'User selected Skip. Preserving infrastructure.'
                        }
                    }
                }
            }
        }
       stage("Deploy Terraform") {
                   steps{
                            dir("terraform/"){
                                         sh "terraform init"
                                         sh "terraform apply --auto-approve"
}
}

}
        stage("Install Docker and other dependencies"){
              steps{
                 sh '''
INSTANCE_ID=$(terraform output -raw instance_id)
             echo $INSTANCE_ID
                      
                      aws ssm send-command \
    --instance-ids "$INSTANCE_ID" \
    --document-name "AWS-RunShellScript" \
    --parameters 'commands=[
        "sudo apt update",
        "sudo apt install -y ca-certificates curl",
        "sudo install -m 0755 -d /etc/apt/keyrings",
        "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
        "sudo chmod a+r /etc/apt/keyrings/docker.asc",
        "echo \"Types: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: \$(. /etc/os-release && echo \"\${UBUNTU_CODENAME:-\$VERSION_CODENAME}\")\nComponents: stable\nArchitectures: \$(dpkg --print-architecture)\nSigned-By: /etc/apt/keyrings/docker.asc\" | sudo tee /etc/apt/sources.list.d/docker.sources",
        "sudo apt update",
        "sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
        "sudo systemctl status docker","
        "sudo systemctl start docker"
 
    ]'
                   aws ssm scp --target $INSTANCE_ID src=./Dockerfile dst=~/
                    '''

                   }
       }
    }
}
