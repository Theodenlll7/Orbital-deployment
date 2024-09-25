@tool
class_name BlackboardHas extends MTLeaf

@export_placeholder(EXPRESION_PLACEHOLDER) var key: String = ""

@onready var key_expression: Expression = parse_expression(key)


func tick(blackboard: Blackboard) -> int:
	var key_value = key_expression.execute([], blackboard)
	return (
		FAILURE
		if key_expression.has_execute_failed() or !blackboard.has_value(key_value)
		else SUCCESS
	)
