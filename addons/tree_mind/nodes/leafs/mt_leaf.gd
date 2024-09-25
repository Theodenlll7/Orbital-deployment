class_name MTLeaf extends MindTreeNode

const EXPRESION_PLACEHOLDER = "Insert Expression here"


# This function parses and evaluates a mathematical expression
func make_expression(expression_str: String) -> Expression:
	var expression: Expression = Expression.new()
	var error_code: int = expression.parse(expression_str)

	if error_code != OK:
		handle_error(expression, expression_str, "Parsing")
		return null

	return expression


func handle_error(expression: Expression, expression_str: String, error_type: String) -> void:
	var error_message = expression.get_error_text()
	push_error("Error ", error_type, " ", expression_str, ": ", error_message)
