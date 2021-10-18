#!/bin/bash
ECR_IMAGE_TAG=latest
IMAGE_META="$( aws ecr list-images --repository-name=$ECR_REPO_NAME --region=$REGION 2> /dev/null )"

if [[ $? == 0 ]]; then
    IMAGE_TAGS="$( echo ${IMAGE_META} | jq '.imageDetails[0].imageTags[0]' -r )"
    echo "$ECR_REPO_NAME:$ECR_IMAGE_TAG found"
else
    echo "$ECR_REPO_NAME:$ECR_IMAGE_TAG not found"

    echo "Pushing image from app repository"

    curl \
    -X POST \
    -H "Accept: application/vnd.github.v3+json" \
    -H "Authorization: Token $APP_REPO_PERSONAL_ACCESS_TOKEN" \
    https://api.github.com/repos/tkav/pathways-node-weather-app/actions/workflows/main.yml/dispatches \
    -d '{"ref":"master"}'

    exit 1
fi