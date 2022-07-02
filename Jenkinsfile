pipeline
{
	agent any
	
	stages
	{
		
		stage('Secret Scanning')
		{
			steps
			{
				sh 'rm trufflehog || true'
				sh 'docker run gesellix/trufflehog --json https://github.com/nitmalviya03/DSVPWA.git > trufflehog'
				sh 'cat trufflehog'
			}
		}
		
		stage ("Python Bandit Security Scan")
		{
			steps
			{
				sh "docker run --rm --volume \$(pwd) secfigo/bandit:latest"
			}
		}
		
		stage ("Static Analysis with python-taint")
		{
			steps
			{
				sh "docker run --rm --volume \$(pwd) vickyrajagopal/python-taint-docker pyt ."
			}
		}	
		
		stage("docker_scan"){
      sh '''
        docker run -d --name db arminc/clair-db
        sleep 15 # wait for db to come up
        docker run -p 6060:6060 --link db:postgres -d --name clair arminc/clair-local-scan
        sleep 1
        DOCKER_GATEWAY=$(docker network inspect bridge --format "{{range .IPAM.Config}}{{.Gateway}}{{end}}")
        wget -qO clair-scanner https://github.com/arminc/clair-scanner/releases/download/v8/clair-scanner_linux_amd64 && chmod +x clair-scanner
        ./clair-scanner --ip="$DOCKER_GATEWAY" myapp:latest || exit 0
      '''
    }
		
		
		stage('Build and Run Web-App')
		{
			steps
			{
				sh '/usr/bin/python3 dsvpwa.py'
			}
		}

	}
}
