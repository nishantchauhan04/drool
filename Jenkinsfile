podTemplate(
    label: 'mypod', 
    inheritFrom: 'default',
    containers: [
        containerTemplate(
            name: 'docker', 
            image: 'docker:18.02',
            ttyEnabled: true,
            command: 'cat'
        ),
        containerTemplate(
            name: 'helm', 
            image: 'ibmcom/k8s-helm:v2.6.0',
            ttyEnabled: true,
            command: 'cat'
        )
    ],
    volumes: [
        hostPathVolume(
            hostPath: '/var/run/docker.sock',
            mountPath: '/var/run/docker.sock'
        )
    ]
) {
    node('mypod') {
        def commitId
        stage ('Extract') {
            checkout scm
            commitId = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
        }
        stage ('Docker-Build') {
            container ('docker') {
                withDockerRegistry([credentialsId: '07bd6c21-6186-44aa-9c9b-cd28aef82b70', url: "" ]) {
                    sh "docker build -t 172.20.184.130:5000/nishantchauhan/edc-drool-1:${commitId} ."
                    sh "docker push 172.20.184.130:5000/nishantchauhan/edc-drool-1:${commitId}"
                }    
            }
        }
        stage ('Deploy') {
            container ('helm') {
            
                    sh "/helm init --client-only --skip-refresh"
                    sh "/helm delete --purge drool1"
                    sh "/helm upgrade --debug --install --namespace default --wait --set service.port=80,image.repository=172.20.184.130:5000/nishantchauhan/edc-drool-1,image.tag=${commitId} drool1 drool1"
            }    
        }
    }
}
