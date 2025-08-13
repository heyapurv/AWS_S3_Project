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

        stage('Get Deployment Info') {
            steps {
                script {
                    BUCKET_NAME = sh(
                        script: "terraform output -raw bucket_name",
                        returnStdout: true
                    ).trim()

                    WEBSITE_URL = sh(
                        script: "terraform output -raw website_url",
                        returnStdout: true
                    ).trim()
                }
            }
        }

        stage('Upload Website Files to S3') {
            steps {
                sh """
                  aws s3 sync . s3://${BUCKET_NAME} \
                    --acl public-read \
                    --delete \
                    --exclude "*.tf*" \
                    --exclude "Jenkinsfile" \
                    --exclude ".git/*"
                """
            }
        }

        stage('Show Website URL') {
            steps {
                echo "🌐 Your site is live at: ${WEBSITE_URL}"
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
