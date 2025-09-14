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
          # tar.gz works everywhere; use 'build' for CRA or 'dist' for Vite
          if [ -d frontend/dist ]; then SRC=dist; else SRC=build; fi
          tar -czf react-app.tar.gz -C frontend $SRC
        '''
      }
    } //Hello
    stage('Upload to S3 (instance role)') {
      steps {
        sh '''
          aws sts get-caller-identity --region ${AWS_REGION}
          aws s3 cp react-app.tar.gz s3://${S3_BUCKET}/react-app.tar.gz --only-show-errors --region ${AWS_REGION}
        '''
      }
    }
  }
}
