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
		
		
		stage ("OPA Conftest")
		{
			steps
			{
				sh "docker run openpolicyagent/opa --policy dockerfile-security.rego Dockerfile"
			}
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
