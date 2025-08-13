pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Deploy Infrastructure with Terraform') {
            steps {
                sh 'terraform init -input=false'
                sh 'terraform apply -auto-approve -input=false'
            }
        }

        stage('Upload Website Files to S3') {
            steps {
                sh '''
                  aws s3 sync . s3://heyapurv-static-site-20250813 \
                    --delete \
                    --exclude "*.tf*" \
                    --exclude "Jenkinsfile" \
                    --exclude ".git/*"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment successful!"
        }
        failure {
            echo "❌ Deployment failed. Check logs."
        }
    }
}
