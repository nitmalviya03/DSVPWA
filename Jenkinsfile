pipeline
{
	agent any
	environment
	{
		DOCKERHUB_CREDENTIALS=credentials('nitesh03')
	}
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
		
		
		stage ("Dependency Check with Python Safety")
		{
			steps
			{
				sh "docker run --rm --volume \$(pwd) pyupio/safety:latest safety check --ignore=43975 --ignore=47833"
			
			}
		}
		
		stage ("SAST")
		{
			steps
			{
			  parallel(
				  "Bandit - SAST":
				  	{
					   sh "docker run --rm --volume \$(pwd) secfigo/bandit:latest"
				  	},
				  "Python-Taint - SAST":
				  	{
					   sh "docker run --rm --volume \$(pwd) vickyrajagopal/python-taint-docker pyt ."	
				  	}
			  	  )
			}
		}
		
		stage ("Docker Vulnerability Scan ")
		{
			steps
			{
			  parallel(
				  "Dockle Scan":
				  	{
					   sh "export DOCKER_CONTENT_TRUST=1"
					   sh "docker build --rm -t dvspwa ."
					   sh "dockle dvspwa"	
				  	},
				  "Trivy Scan":
				  	{
					   sh "docker build --rm -t dvspwa ."
					   sh "trivy image dvspwa"	
				  	}
			  	  )
			}
		}
		
		
		 stage('Kubernetes Scanning') 
		{

			steps 
			{
			sh 'curl --silent --compressed --connect-timeout 5 https://kubesec.io -F file=@"deployment.yaml"'
			}
		}
		
	}
}
