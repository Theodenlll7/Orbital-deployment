class_name ForTime extends MTDecorator

@export var run_time: float = 1

var timer = 0

func tick(blackboard: Blackboard) -> int:
	timer += blackboard.delta_time
	var respons = child.tick(blackboard)
	if respons == FAILURE:
		timer = 0
		return FAILURE
	elif timer >= run_time:
		if respons == SUCCESS:
			timer = 0
			return SUCCESS
	return RUNNING
