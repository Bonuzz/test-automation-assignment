pipeline {
    agent any
    
    stages {
        stage('Checkout Code From Git') {
            steps {
                echo 'Checking out code from Git repository...'
                // Clone the repository
                git branch: 'main',
                    url: 'https://github.com/Bonuzz/test-automation-assignment.git'
                
                echo 'Code checkout completed successfully'
            }
        }
        
        stage('Run Test Automate') {
            steps {
                echo 'Running automated tests...'
                
                // Install dependencies
                sh '''
                    pip install -r requirements.txt
                '''
                
                // Run Robot Framework tests
                sh '''
                    robot --outputdir results tests/
                '''
                
                echo 'Tests execution completed'
            }
        }
        
        stage('Send Result To Jenkins') {
            steps {
                echo 'Publishing test results...'
                
                // Publish Robot Framework results
                robot(
                    outputPath: 'results',
                    outputFileName: 'output.xml',
                    reportFileName: 'report.html',
                    logFileName: 'log.html',
                    disableArchiveOutput: false,
                    passThreshold: 100,
                    unstableThreshold: 80,
                    otherFiles: '**/*.png'
                )
                
                echo 'Test results published to Jenkins'
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
