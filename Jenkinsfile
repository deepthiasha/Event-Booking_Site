pipeline {
  agent any

  environment {
    AWS_REGION = 'us-east-1'
    S3_BUCKET  = 'eventsbookings3'
    BUILD_DIR  = 'dist'    
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Build & Package (frontend)') {
      steps {
        dir('frontend') {
          sh '''
            npm ci || npm install
            npm run build
            [ -d "${BUILD_DIR}" ] || { echo "ERROR: ${BUILD_DIR} not found"; exit 1; }
            rm -f react-app.zip
            zip -r react-app.zip "${BUILD_DIR}/"
            mv react-app.zip "$WORKSPACE/react-app.zip"
          '''
        }
      }
    }

    stage('Upload to S3') {
      steps {
        withAWS(region: "${AWS_REGION}", credentials: 'aws-s3-direct') {
          sh 'aws s3 cp "$WORKSPACE/react-app.zip" "s3://${S3_BUCKET}/react-app.zip" --only-show-errors'
        }
      }
    }
  }
}
