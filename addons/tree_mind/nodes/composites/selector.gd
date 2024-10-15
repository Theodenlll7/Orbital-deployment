@tool
@icon("../../icons/selector.svg")
class_name Selector extends Composite

var running_index : int = -1

func tick(blackboard: Blackboard) -> int:
	if running_index != -1:
		var state = get_child(running_index).tick(blackboard)
		match state:
			RUNNING:
				return state
			SUCCESS:
				running_index = -1
				return state
		
	for i in range(get_child_count()):
		var c = get_child(i)
		var state = c.tick(blackboard)
		match state:
			RUNNING:
				running_index = i
				return state
			SUCCESS:
				return state
	return FAILURE
