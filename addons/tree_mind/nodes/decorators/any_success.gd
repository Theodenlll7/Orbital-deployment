class_name AnySuccess extends MTDecorator

func tick(blackboard: Blackboard) -> int:
	for child in get_children():
		var status = child.tick(blackboard)
		if status != FAILURE:
			return status
	return FAILURE
