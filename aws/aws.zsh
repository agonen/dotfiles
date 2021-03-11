export aws_cli_auto_prompt=on
#aws_cli_auto_prompt=on-partial

ecs_logs(){
	ecs-cli logs --task-id $1 --follow
}

alias ecs_ps="ecs-cli ps"

