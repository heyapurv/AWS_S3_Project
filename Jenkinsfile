// Jenkinsfile

pipeline {
    agent any

    environment {
        // Set these as Jenkins credentials
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Fetches the code from your Git repository
                checkout scm
            }
        }

        stage('Deploy Infrastructure with Terraform') {
            steps {
                // Initialize Terraform and apply the configuration
                sh 'terraform init'
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Upload Website Files to S3') {
            steps {
                // Use the AWS CLI to sync your website files to the S3 bucket
                // The bucket name here must match the one in your main.tf
                sh 'aws s3 sync . s3://your-unique-website-bucket-name --acl public-read --delete'
            }
        }
    }
}