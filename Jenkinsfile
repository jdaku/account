node {

	def app
	def mvnCMD = "/usr/bin/mvn"
    	def Namespace = "default"
  	def ImageName = "ravigajjar/account"
	def hostname = InetAddress.localHost.canonicalHostName
	def URL = "curl -sL --connect-timeout 20 --max-time 30 -w '%{http_code}\\n'  ${hostname}:8082/account/login  -o /dev/null"
	try{ 
		stage('Clone repository') {
			checkout scm
		        sh "git rev-parse --short HEAD > .git/commit-id"
      			imageTag= readFile('.git/commit-id').trim()
		}
		stage('Mvn Compile') {	
			sh "${mvnCMD} compile "
		}
		stage('Mvn Package') {			
			sh "${mvnCMD} clean package "
		}
		stage("Build Docker Image") {
			 app = docker.build("ravigajjar/account")
		}
		stage('Push image') {	
	  	         docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-creds') {
	   	         	app.push("${env.BUILD_NUMBER}")
    		        	app.push("latest")
        			}
		} 
/*		stage('Deploy on aws'){
		sh "docker-compose down"
		sh "docker-compose pull && docker-compose up -d"
		} */
		stage('Deploy on K8s'){

    		 	sh "ansible-playbook ansible/app-deploy/deploy.yml  --user=jenkins --extra-vars ImageName=${ImageName} --extra-vars imageTag=${imageTag} --extra-vars Namespace=${Namespace}"
    		}
		stage('Test URL') {
            		
                		sleep(time:20,unit:"SECONDS")
					sh "${URL} > commandResult"
                    			env.status = readFile('commandResult').trim()
                    			sh "echo ${env.status}"
				script {
                		
				     if (env.status == '200') {
				                echo "URL TEST OK"
                        			currentBuild.result = "SUCCESS"
                        			
                    			}
                    			else {
                    			        echo "URL TEST KO"
                        			currentBuild.result = "FAILURE"
                   			 }
            		
			}
		}
	}
      	catch (err) {
      	currentBuild.result = 'FAILURE'
  	}	
    
}
