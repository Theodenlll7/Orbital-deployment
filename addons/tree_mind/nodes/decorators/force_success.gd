class_name ForceSuccess extends Decorator


func tick(blackboard: Blackboard) -> int:
	child.tick(blackboard)
	return SUCCESS
