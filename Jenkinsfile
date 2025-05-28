// pipeline {
 
//     agent any
 
//     parameters {
 
//         string(name: 'DEST_USER', defaultValue: 'cdudi', description: 'Destination username')
 
//         string(name: 'DEST_HOSTS', defaultValue: '10.128.0.24,10.128.0.28', description: 'Comma-separated destination IPs')
 
//         string(name: 'DEST_PATH', defaultValue: '/home/cdudi/', description: 'Target path on remote hosts')
 
//         string(name: 'FILE_NAME', defaultValue: 'data5.csv', description: 'CSV file to transfer')
 
//     }
 
//     environment {
 
//         LOG_FILE = 'logs/transfer.log'
 
//     }
 
//     stages {
 
//         stage('Checkout SCM') {
 
//             steps {
 
//                 checkout scm
 
//             }
 
//         }
 
//         stage('Transfer CSV Files in Parallel') {
 
//             steps {
 
//                 script {
 
//                     def hosts = params.DEST_HOSTS.split(',')
 
//                     def parallelSteps = [:]
 
//                     for (int i = 0; i < hosts.size(); i++) {
 
//                         def host = hosts[i].trim()
 
//                         parallelSteps["Transfer to ${host}"] = {
//                             sh """
//                                 mkdir -p logs
//                                 echo "===== Transfer Start to ${host} =====" >> logs/transfer_${host}.log
//                                 pwsh -File ./transfer.ps1 -DestinationUser "${params.DEST_USER}" -DestinationHosts "${host}" -CsvFilePath "${params.FILE_NAME}" -TargetPath "${params.DEST_PATH}" >> logs/transfer_${host}.log 2>&1
//                                 echo "===== Transfer End to ${host} =====" >> logs/transfer_${host}.log
//                             """
//                         }
 
//                     }
 
//                     parallel parallelSteps
 
//                 }
 
//             }
 
//         }
 
//     }
 
//     post {
 
//         always {
 
//             archiveArtifacts artifacts: 'logs/*.log', fingerprint: true
 
//             emailext(
//                 subject: "${currentBuild.currentResult}: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
//                 body: """<p>Job ${currentBuild.currentResult}</p>
// <p>Job: ${env.JOB_NAME}<br/>
// Build Number: ${env.BUILD_NUMBER}<br/>
// <a href='${env.BUILD_URL}'>View Build</a></p>""",
//                 to: 'chiranjeevigen@gmail.com',
//                 from: 'chiranjeevidudi3005@gmail.com',
//                 attachmentsPattern: 'logs/*.log'
//             )
 
//         }
 
//     }
 
// }

pipeline {
 
    agent any
 
    parameters {
 
        string(name: 'DEST_USER', defaultValue: 'cdudi', description: 'Destination username')
 
        string(name: 'DEST_HOST', defaultValue: 'ALL', description: 'Target host IP or "ALL" for all')
 
        string(name: 'DEST_PATH', defaultValue: '/home/cdudi/', description: 'Target path on remote host(s)')
 
        string(name: 'FILE_NAME', defaultValue: 'data5.csv', description: 'CSV file to transfer')
 
    }
 
    environment {
        LOG_FILE = 'logs/transfer.log'
        ALL_HOSTS = '10.128.0.24,10.128.0.28'
    }
 
    stages {
 
        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }
 
        stage('Transfer CSV Files') {
            steps {
                script {
 
                    def targetHosts = (params.DEST_HOST.trim() == 'ALL') 
                                      ? env.ALL_HOSTS.split(',') 
                                      : [params.DEST_HOST.trim()]
 
                    def parallelSteps = [:]
 
                    for (host in targetHosts) {
                        def cleanHost = host.trim()
                        parallelSteps["Transfer to ${cleanHost}"] = {
                            sh """
                                mkdir -p logs
                                echo "===== Transfer Start to ${cleanHost} =====" >> logs/transfer_${cleanHost}.log
                                pwsh -File ./transfer.ps1 -DestinationUser "${params.DEST_USER}" -DestinationHosts "${cleanHost}" -CsvFilePath "${params.FILE_NAME}" -TargetPath "${params.DEST_PATH}" >> logs/transfer_${cleanHost}.log 2>&1
                                echo "===== Transfer End to ${cleanHost} =====" >> logs/transfer_${cleanHost}.log
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