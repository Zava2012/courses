@Library('mylib@master') _

pipeline {
    agent {
        label 'docker'
    }

    // tools {
    //     dockerTool 'docker'
    // }

    options {
        buildDiscarder logRotator(numToKeepStr: '5')
        timestamps()
    }

    // parameters {
    //     choice choices: ['first choice', 'second choice', 'third choice', 'my choice'], name: 'MYCHOICE'
    // }

    // triggers {
    //     cron '*/5 * * * *'
    // }

    environment {
        IMAGE_REPO = 'myusername/jenkins'
        TAG = sh(script: "jq -r .version package.json", returnStdout: true).trim()
    }

    stages {
        stage('Tests') {
            agent {
                docker {
                    image 'node:14-alpine'
                    label 'docker'
                }
            }

            // when {
            //     changeset 'test/*.js'
            //     beforeAgent true
            // }

            when {
                changeRequest()
                // branch 'master'
                beforeAgent true
            }

            steps {
                sh '''
                echo $MYCHOICE
                npm ci
                npm test
                '''

                // stash(
                //     includes: '**/test-results.xml',
                //     name: 'mystash'
                // )
            }
            post {
                always {
                    recordIssues(
                        enabledForFailure: true,
                        tools: [
                            junitParser(pattern: '**/test-results.xml')
                        ]
                    )
                }
            }
        }

        stage('Build') {
            steps {
                // unstash 'mystash'
                // sh 'cat test-results.xml'

                myVars('me')

                withDockerRegistry(credentialsId: 'dockerhub', url: 'https://index.docker.io/v1/') {
                    sh '''
                    printenv
                    docker build -t $IMAGE_REPO:$TAG-$GIT_COMMIT -t $IMAGE_REPO:latest ./
                    docker push $IMAGE_REPO:$TAG-$GIT_COMMIT
                    docker push $IMAGE_REPO:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            environment {
                NAMESPACE = 'mynamespace'
            }

            input {
                message 'Do you want to deploy on Production'
            }

            steps {
                sh '''
                tmpfile=$(mktemp)
                for i in kubernetes/*.yaml; do
                    cat $i | envsubst > $tmpfile
                    cp -pf $tmpfile $i
                    rm -f "$tmpfile"
                done
                '''

                withCredentials([kubeconfigFile(credentialsId: 'freestyle-kubeconfig', variable: 'KUBECONFIG')]) {
                    sh 'kubectl -n $NAMESPACE apply -f kubernetes/'
                }
            }
        }
    }

    post {
        cleanup {
            cleanWs()
        }
    }
}
