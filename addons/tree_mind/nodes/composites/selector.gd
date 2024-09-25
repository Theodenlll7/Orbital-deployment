@tool
@icon("../../icons/selector.svg")
class_name Selector extends Composite


func tick(blackboard: Blackboard) -> int:
	for c: MindTreeNode in get_children():
		var state = c.tick(blackboard)
		if state == RUNNING or state == SUCCESS:
			return state
	return FAILURE
