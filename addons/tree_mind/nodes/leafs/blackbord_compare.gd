@tool
class_name BlackboardCompare extends MTLeaf

@export var key: String = ""


func tick(blackboard: Blackboard) -> int:
	if blackboard.has_value(key):
		return SUCCESS
	return FAILURE
