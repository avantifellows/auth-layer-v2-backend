#!/bin/bash

# extract TARGET_GROUP_NAME from .env file and store it in an environment variable
TARGET_GROUP_NAME=$(grep TARGET_GROUP_NAME .env | cut -d '=' -f2)

# Define variables
echo "[EC2 Action] Defining variables..."
targetGroupName=$TARGET_GROUP_NAME
region="ap-south-1" # replace with your actual region
account_id="111766607077" # replace with your actual account ID

# Fetch the ARN of the target group by its name
echo "[EC2 Action] Fetching ARN for target group named $targetGroupName..."
targetGroupArn=$(aws elbv2 describe-target-groups --names $targetGroupName --query "TargetGroups[0].TargetGroupArn" --output text --region $region)

# Check if we successfully retrieved the ARN
if [ -z "$targetGroupArn" ]; then
    echo "[EC2 Action] Error: Could not retrieve ARN for target group named $targetGroupName."
    exit 1
fi

echo "[EC2 Action] Found ARN for target group: $targetGroupArn"

keyPath="/home/ubuntu/AvantiFellows.pem"
envFile="/home/ubuntu/.env"
pathToCloudwatchConfig="/home/ubuntu/db-service/deployment/cloudwatch-agent-config.json"

# Fetch the instance IDs of the target group using the ARN
echo "[EC2 Action] Fetching instance IDs of the target group..."
instanceIds=$(aws elbv2 describe-target-health --target-group-arn $targetGroupArn --query "TargetHealthDescriptions[*].Target.Id" --output text --region $region)

echo "[EC2 Action] Fetching private IP addresses of the instances..."
privateIps=$(aws ec2 describe-instances --instance-ids $instanceIds --query "Reservations[*].Instances[*].PrivateIpAddress" --output text --region $region)

# Convert the space-separated strings into arrays
instanceIdsArray=($instanceIds)
privateIpsArray=($privateIps)

# extract BRANCH_NAME_TO_DEPLOY from .env file and store it in an environment variable
BRANCH_NAME_TO_DEPLOY=$(grep BRANCH_NAME_TO_DEPLOY $envFile | cut -d '=' -f2)

for i in "${!instanceIdsArray[@]}"; do
    id=${instanceIdsArray[$i]}
    private_ip=${privateIpsArray[$i]}
    echo "[EC2 Action] Processing instance ID: $id"

    # Get private IP of the instance
    echo "[EC2 Action] Getting private IP of instance $id..."
    instanceIp=$(aws ec2 describe-instances --instance-ids $id --query "Reservations[*].Instances[*].PrivateIpAddress" --output text)

    echo "[EC2 Action] Changing access permissions for the directory..."
    ssh -o StrictHostKeyChecking=no -i $keyPath ubuntu@$instanceIp "sudo chown -R ubuntu:ubuntu /home/ubuntu/db-service"

    # Transfer .env file
    echo "[EC2 Action] Transferring .env file to instance $id at IP $instanceIp..."
    scp -o StrictHostKeyChecking=no -i $keyPath $envFile ubuntu@$instanceIp:/home/ubuntu/db-service

    # Execute commands on the instance
    echo "[EC2 Action] Executing commands on instance $id..."
    # RANDOM_MINUTE=$((9 + RANDOM % (15 - 9 + 1)))
    RANDOM_MINUTE=$((2 + RANDOM % (4 - 2 + 1)))
    echo "Random minute: $RANDOM_MINUTE"
    ssh -o StrictHostKeyChecking=no -i $keyPath ubuntu@$instanceIp << EOF
        echo "[EC2 Action] Stopping any process running on port 80..."
        sudo fuser -k 80/tcp
        sudo su
        echo "[EC2 Action] Updating codebase and restarting the application..."
        cd /home/ubuntu/db-service
        git stash
        echo "Changed directory to /home/ubuntu/db-service"
        git checkout $BRANCH_NAME_TO_DEPLOY
        echo "Checked out branch $BRANCH_NAME_TO_DEPLOY"
        git pull origin $BRANCH_NAME_TO_DEPLOY
        echo "Pulled latest changes from $BRANCH_NAME_TO_DEPLOY"
        echo $id
        echo "HOST_IP=$instanceIp" >> .env
        echo "PHX_HOST=$instanceIp" >> .env
        echo "Added host ip to .env file"
        sudo MIX_ENV=prod mix deps.get
        echo "Installed dependencies..."
        sudo MIX_ENV=prod mix deps.compile
        echo "Compiled dependencies..."
        echo "Running Migrations..."
        sudo MIX_ENV=prod mix ecto.migrate
        echo "Migrations ran successfully"
        sudo MIX_ENV=prod mix phx.swagger.generate
        echo "Generated swagger file"
        sudo sudo MIX_ENV=prod elixir --erl "-detached" -S mix phx.server
        echo "Starting Db service server..."
EOF
    echo "[EC2 Action] Completed actions on instance $id."
done

echo "[EC2 Action] Completed updating all instances in target group."