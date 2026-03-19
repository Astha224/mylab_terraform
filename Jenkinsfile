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
                nexusArtifactUploader artifacts: [[artifactId: 'asthaDevOpsLab', classifier: '', file: 'target/asthaDevOpsLab-0.0.4.war', type: 'war']], credentialsId: '', groupId: 'com.asthadevopslab', nexusUrl: '172.20.10.111:808', nexusVersion: 'nexus2', protocol: 'http', repository: 'asthalab-snapshot', version: '0.0.4'
            }


        }

        stage ('Deploy'){
            steps {
                echo ' Deploying......'

            }
        }

    }

}