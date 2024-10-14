class_name Delayer extends MTDecorator

@export var wait_time: float = 1

var timer = 0


func tick(blackboard: Blackboard) -> int:
	timer += blackboard.delta_time
	var respons = RUNNING
	if timer >= wait_time:
		respons = child.tick(blackboard)
		if respons != RUNNING:
			timer = 0
	return respons
