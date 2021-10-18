#!/bin/bash
ECR_IMAGE_TAG=latest
ALB_DNS_NAME=$(aws ssm get-parameter --name ${ALB_DNS_PARAMETER_NAME} --region ${REGION} --output text --query Parameter.Value)
IMAGE_META="$( aws ecr batch-get-image --repository-name=$ECR_REPO_NAME --image-ids=imageTag=$ECR_IMAGE_TAG --region=$REGION --output text )"

if [[ $? == 0 ]]; then
    IMAGE_TAGS="$( echo ${IMAGE_META} | jq '.imageDetails[0].imageTags[0]' -r )"
    echo "$ECR_REPO_NAME:$ECR_IMAGE_TAG found"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"ECR image exists. App should be available at '"$ALB_DNS_NAME"'"}' $SLACK_WEBHOOK
else
    echo "$ECR_REPO_NAME:$ECR_IMAGE_TAG not found"

    echo "Pushing image from app repository"
    curl -X POST -H 'Content-type: application/json' --data '{"text":"Pushing image to ECR. App will be available soon at '"$ALB_DNS_NAME"'"}' $SLACK_WEBHOOK

    curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Token $APP_REPO_PERSONAL_ACCESS_TOKEN" \
    https://api.github.com/repos/tkav/pathways-node-weather-app/actions/workflows/main.yml/dispatches \
    -d '{"ref":"master"}'

    exit 1
fi
