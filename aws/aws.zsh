export aws_cli_auto_prompt=on
#aws_cli_auto_prompt=on-partial

ecs_logs(){
	ecs-cli logs --task-id $1 --follow
}

ecs_start_task(){
    task=$1
    aws ecs run-task --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1 --cluster data --task-definition $task  --count 1    --region us-east-1
 #   aws ecs run-task --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1 --cluster data --task-definition $task  --count 1  --network-configuration "awsvpcConfiguration={subnets=[subnet-d4a2dcfa,subnet-9f493af8],securityGroups=[sg-e3cb1e57b],assignPublicIp=ENABLED}"  --region us-east-1
}

ecs_tracker(){
    aws ecs run-task --capacity-provider-strategy capacityProvider=FARGATE_SPOT,weight=1 --cluster data --task-definition tracker --count 1 --network-configuration "awsvpcConfiguration={subnets=[subnet-d4a2dcfa,subnet-9f493af8],securityGroups=[sg-3cb1e57b],assignPublicIp=ENABLED}" --region us-east-1
}

alias ecs_ps="ecs-cli ps"

alias pip_refresh_token="aws codeartifact login --tool pip --repository data --domain elementor-data --domain-owner 061538166779"
alias twine_refresh_token="aws codeartifact login --tool twine --repository data --domain elementor-data --domain-owner 061538166779"
