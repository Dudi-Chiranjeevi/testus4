pipeline {
 
    agent any
 
    parameters {
 
        string(name: 'DEST_USER', defaultValue: 'cdudi', description: 'Destination username')
 
        string(name: 'DEST_HOSTS', defaultValue: '10.128.0.24,10.128.0.28', description: 'Comma-separated destination IPs')
 
        string(name: 'DEST_PATH', defaultValue: '/home/cdudi/', description: 'Target path on remote hosts')
 
        string(name: 'FILE_NAME', defaultValue: 'data5.csv', description: 'CSV file to transfer')
 
    }
 
    environment {
 
        LOG_FILE = 'logs/transfer.log'
 
    }
 
    stages {
 
        stage('Checkout SCM') {
 
            steps {
 
                checkout scm
 
            }
 
        }
 
        stage('Transfer CSV Files in Parallel') {
 
            steps {
 
                script {
 
                    def hosts = params.DEST_HOSTS.split(',')
 
                    def parallelSteps = [:]
 
                    for (int i = 0; i < hosts.size(); i++) {
 
                        def host = hosts[i].trim()
 
                        parallelSteps["Transfer to ${host}"] = {
                            sh """
                                mkdir -p logs
                                echo "===== Transfer Start to ${host} =====" >> logs/transfer_${host}.log
                                pwsh -File ./transfer.ps1 -DestinationUser "${params.DEST_USER}" -DestinationHosts "${host}" -CsvFilePath "${params.FILE_NAME}" -TargetPath "${params.DEST_PATH}" >> logs/transfer_${host}.log 2>&1
                                echo "===== Transfer End to ${host} =====" >> logs/transfer_${host}.log
                            """
                        }
 
                    }
 
                    parallel parallelSteps
 
                }
 
            }
 
        }
 
    }
 
    post {
 
        always {
 
            archiveArtifacts artifacts: 'logs/*.log', fingerprint: true
 
            emailext(
                subject: "${currentBuild.currentResult}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
                body: """<p>Job ${currentBuild.currentResult}</p>
<p>Job: ${env.JOB_NAME}<br/>
Build Number: ${env.BUILD_NUMBER}<br/>
<a href='${env.BUILD_URL}'>View Build</a></p>""",
                to: 'chiranjeevigen@gmail.com',
                from: 'chiranjeevidudi3005@gmail.com',
                attachmentsPattern: 'logs/*.log'
            )
 
        }
 
    }
 
}