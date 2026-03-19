pipeline{
    //Directives
    agent any
    tools {
        maven 'maven'
    }

    stages {
        // Specify various stage with in stages

        // stage 1. Build
        stage ('Build'){
            steps {
                sh 'mvn clean install package'
            }
        }

        // Stage2 : Testing
        stage ('Test'){
            steps {
                echo ' testing......'

            }
        }

        stage('Publish to Nexus'){
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'asthaDevOpsLab', classifier: '', file: 'target/asthaDevOpsLab-0.0.4.war', type: 'war']], credentialsId: 'e9526411-f47b-4d24-b61d-34a922803245', groupId: 'com.asthadevopslab', nexusUrl: '18.222.192.9:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'asthalab-snapshot', version: '0.0.4'
            }


        }

        stage ('Deploy'){
            steps {
                echo ' Deploying......'

            }
        }

    }

}