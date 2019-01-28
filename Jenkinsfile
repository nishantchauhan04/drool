podTemplate(
    label: 'mypod', 
    inheritFrom: 'default',
    containers: [
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
        stage ('Deploy') {
            container ('helm') {
            
                    sh "/helm init --client-only --skip-refresh"
                    sh "/helm delete --purge drool1"
                    sh "/helm upgrade --debug --install --namespace default --wait --set service.port=80,service.name=drools-workbench-custom-service,image.repository=172.20.128.96:5000/nishantchauhan/edc-drool-1,image.tag=${commitId} drool1 drool1"
            }    
        }
    }
}
