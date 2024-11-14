pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Cloning the Moodle repo
                checkout scm
            }
        }
        
        stage('Build and Start Services') {
            steps {
                // Build and start services defined in the Docker Compose file
                sh 'docker-compose up -d --build'
            }
        }
        
        stage('Run Tests') {
            steps {
                // Run tests within the Moodle container (adjust the service name as needed)
                sh 'docker-compose exec moodle-container vendor/bin/phpunit'
            }
        }
        
        stage('Stop Services') {
            steps {
                // Stop and remove all services defined in the Docker Compose file
                sh 'docker-compose down'
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed. Cleaning up if necessary.'
            // Optional: Clean up dangling images and containers
            sh 'docker system prune -f'
        }
    }
}
