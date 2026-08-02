pipeline {
    agent any 
    environment {
     git_url = "https://github.com/Sagarmal47/Final-project-2.git"
   }
stages{
   stage("Git Checkout ")
      steps{
          sh "git clone ${var.git_url}"
                }

}
}
