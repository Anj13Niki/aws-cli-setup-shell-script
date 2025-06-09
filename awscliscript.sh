
#!/bin/bash


install_aws_cli(){
	echo "Installing AWS CLI...."
	#Installing dependencies if not there
	
	if ! command -v curl &>/dev/null; then
		echo "Installing curl.."
		sudo apt update && sudo apt install curl -y
	fi

	if ! command -v unzip &>/dev/null; then
		echo "Uninstalling unzip..."
		sudo apt install unzip -y
	fi

	#Remove old installer
	
	rm -rf awscliv2.zip aws

	#Download AWS CLI installer
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to download AWS CLI Installer."
		exit 1
	fi
	
	#Unzip Installer
	unzip awscliv2.zip
	if [ $? -ne 0 ]; then
		echo "ERROR: Failed to uzip AWS CLI installer."
		exit 1
	fi

	#Run install
	sudo ./aws/install
	if [ $? -ne 0 ]; then
		echo "ERROR: AWS CLI installation failed."
		exit 1
	fi

	#Cleanup
	
	rm -f awscliv2.zip aws

	#Add AWS CLI TO PATH 
	export PATH=$PATH:/usr/local/bin:/usr/local/aws-cli/v2/current/bin

	echo "AWS CLI installed successfully."
	aws  --version
}

check_aws_cli_installed(){
	if command -v aws &>/dev/null; then
		echo "AWS CLI already instaled."
		return 0
	else
		echo "AWS CLI not found."
		return 1
	fi

}

configure_aws_cli(){
	echo "Configuring AWS CLI...."
	aws configure
}

test_aws_connection(){
	echo "Testing AWS CLI connection.."
	aws sts get-caller-identity >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		echo "AWS CLI is configured and working..."
		return 0
	else
		echo "AWS CLI is not configured correctly.."
		return 1
	fi
}


check_aws_cli_installed
if [ $? -ne 0 ]; then
	install_aws_cli
fi

# Make sure aws command is in current shell path after install
export PATH=$PATH:/usr/local/bin:/usr/local/aws-cli/v2/current/bin


configure_aws_cli

test_aws_connection
if [ $? -ne 0 ]; then
	    echo "Please check your AWS credentials and network connection."
	    exit 1
fi



echo "Setup complete."
