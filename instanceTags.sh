#!/bin/bash

# Define the tag key and value you want to check/add
TAG_KEY="Environment"
TAG_VALUE="Production"

# Get all EC2 instance IDs
INSTANCE_IDS=$(aws ec2 describe-instances --query "Reservations[*].Instances[*].InstanceId" --output text)

# Loop through each instance
for INSTANCE_ID in $INSTANCE_IDS; do
    # Check if the instance already has the tag
    TAG_EXISTS=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_KEY" --query "Tags[*].Value" --output text)

    if [ -z "$TAG_EXISTS" ]; then
        echo "Instance $INSTANCE_ID is missing tag. Adding $TAG_KEY=$TAG_VALUE"
        aws ec2 create-tags --resources $INSTANCE_ID --tags Key=$TAG_KEY,Value=$TAG_VALUE
    else
        echo "Instance $INSTANCE_ID already has tag $TAG_KEY=$TAG_EXISTS"
    fi
done
