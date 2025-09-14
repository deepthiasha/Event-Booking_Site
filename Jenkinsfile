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

    stage('Tool versions') {
      steps {
        powershell '''
          node -v
          npm -v
          aws --version
        '''
      }
    }

    stage('Build & Package (frontend)') {
      steps {
        dir('frontend') {
          powershell '''
            # Install deps & build
            npm ci 2>$null; if ($LASTEXITCODE -ne 0) { npm install }
            npm run build

            # Validate build dir
            if (-not (Test-Path "$env:BUILD_DIR")) {
              Write-Error "ERROR: $env:BUILD_DIR not found. Set BUILD_DIR correctly (dist/build)."
              exit 1
            }

            # Create zip at workspace root
            $zipPath = Join-Path $env:WORKSPACE "react-app.zip"
            if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
            Compress-Archive -Path (Join-Path $env:BUILD_DIR '*') -DestinationPath $zipPath -Force

            Write-Host "Packaged: $zipPath"
          '''
        }
      }
    }

    stage('Upload to S3') {
      steps {
        withAWS(region: "${AWS_REGION}", credentials: 'aws-s3-direct') {
          powershell '''
            $zipPath = Join-Path $env:WORKSPACE "react-app.zip"
            aws s3 cp "$zipPath" "s3://eventsbookings3/react-app/react-app.zip" --only-show-errors
          '''
        }
      }
    }
  }
}
