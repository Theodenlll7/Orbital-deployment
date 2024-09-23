class_name RandomSelector extends MindTreeTask


func tick(blackboard: Blackboard) -> int:
	var children = get_children()
	children.shuffle()
	for c: MindTreeTask in children:
		var state = c.tick(blackboard)
		if state == RUNNING or SUCCESS:
			return state
	return FAILURE
