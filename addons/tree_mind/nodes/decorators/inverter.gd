class_name Inverter extends MTDecorator


func tick(blackboard: Blackboard) -> int:
	match child.tick(blackboard):
		SUCCESS:
			return FAILURE
		FAILURE:
			return SUCCESS
	return RUNNING
