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
		
		stage ("Dependency Check with Python Safety")
		{
			steps
			{
				sh "docker run --rm --volume \$(pwd) pyupio/safety:latest safety check"
				sh "docker run --rm --volume \$(pwd) pyupio/safety:latest safety check --json > report.json"
			}
		}
		
		stage ("Docker Dockle Scan")
		{
			steps
			{
				sh "docker build --rm -t dvspwa:latest ."
				sh "dockle dvspwa"
			}
		}
		
		stage ("Docker Trivy Scan")
		{
			steps
			{
				sh "trivy image dvspwa"
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
