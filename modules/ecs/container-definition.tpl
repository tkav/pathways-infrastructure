[
    {
        "name": "${name_prefix}-weather-app",
        "image": "${ecr-repo-uri}",
        "portMappings": [
            {
                "protocol": "tcp",
                "containerPort": ${port}
            }
        ],
        "memory": ${memory},
        "cpu": ${cpu},
        "requiresCompatibilities": [
        "FARGATE"
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${cloudwatch_group}",
                "awslogs-region": "${aws_region}",
                "awslogs-stream-prefix": "streaming"
            }
        },
        "networkMode": "awsvpc",
        "executionRoleArn": "${execution-role-arn}"
    }
]