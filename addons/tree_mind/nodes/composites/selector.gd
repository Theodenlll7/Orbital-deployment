class_name Selector extends Composite

func tick(blackboard: Blackboard) -> int:
	for c: MindTreeTask in get_children():
		var state = c.tick(blackboard)
		if state == RUNNING or SUCCESS:
			return state
	return FAILURE
