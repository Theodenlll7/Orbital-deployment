class_name ForceSuccess extends MTDecorator


func tick(blackboard: Blackboard) -> int:
	child.tick(blackboard)
	return SUCCESS
