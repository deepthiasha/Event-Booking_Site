pipeline {
  agent any
  environment {
    AWS_REGION = 'us-east-1'
    S3_BUCKET  = 'eventsbookings3'
    BUILD_DIR  = 'dist'   
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
          # create tar.gz without needing zip installed
          tar -czf react-app.tar.gz -C frontend ${BUILD_DIR}
        '''
      }
    }

    stage('Upload to S3') {
      steps {
        withAWS(region: "${AWS_REGION}", credentials: 'aws-cred') {
          sh 'aws s3 cp react-app.tar.gz s3://${S3_BUCKET}/react-app.tar.gz --only-show-errors'
        }
      }
    }
  }
}
