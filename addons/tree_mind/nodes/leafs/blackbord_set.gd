@tool
class_name BlackboardSet extends MTLeaf

@export_placeholder(EXPRESION_PLACEHOLDER) var key: String = ""
@export_placeholder(EXPRESION_PLACEHOLDER) var value: String = ""

@onready var key_expression: Expression = make_expression(key)
@onready var value_expression: Expression = make_expression(value)


func tick(blackboard: Blackboard) -> int:
	var _key: Variant = key_expression.execute([], blackboard)
	var _value: Variant = value_expression.execute([], blackboard)

	if key_expression.has_execute_failed() or value_expression.has_execute_failed():
		return FAILURE

	blackboard.set_value(_key, _value)
	return SUCCESS
