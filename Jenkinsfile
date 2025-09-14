pipeline {
  agent any
  environment {
    AWS_REGION = 'us-east-1'
    S3_BUCKET  = 'eventsbookings3'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build') {
      steps {
        sh '''
          cd frontend
          npm ci || npm install
          npm run build
          cd ..
          zip -r react-app.zip frontend/build
        '''
      }
    }
    stage('Upload to S3') {
      steps {
        withAWS(region: "${AWS_REGION}", credentials: 'aws-cred') {
          sh 'aws s3 cp react-app.zip s3://${S3_BUCKET}/react-app.zip --only-show-errors'
        }
      }
    }
  }
}
