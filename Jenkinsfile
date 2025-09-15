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
          set -e
          cd frontend
          npm ci || npm install
          npm run build
        '''
      }
    }

    stage('Package for CodeDeploy') {
      steps {
        sh '''
          set -e
          # pick build dir: Vite=dist, CRA=build
          BUILD_DIR=$( [ -d frontend/dist ] && echo frontend/dist || echo frontend/build )
          [ -d "$BUILD_DIR" ] || { echo "No dist/ or build/ found"; exit 1; }

          # ONE archive: appspec.yml at root + build contents at root
          tar -czf react-app.tar.gz appspec.yml -C "$BUILD_DIR" .

          # sanity (optional)
          tar -tzf react-app.tar.gz | head -20
        '''
      }
    }

    stage('Upload to S3') {
      steps {
        sh '''
          aws sts get-caller-identity --region ${AWS_REGION}
          aws s3 cp react-app.tar.gz s3://${S3_BUCKET}/react-app.tar.gz \
            --region ${AWS_REGION} --only-show-errors
        '''
      }
    }
  }
}
//
