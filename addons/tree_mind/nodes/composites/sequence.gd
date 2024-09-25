@tool
@icon("../../icons/sequance.svg")
class_name Sequance extends Composite

var succes_index = 0


func tick(blackboard: Blackboard) -> int:
	for i in range(succes_index, get_child_count()):
		var c = get_child(i)
		var state = c.tick(blackboard)
		match state:
			RUNNING:
				return RUNNING
			SUCCESS:
				succes_index += 1
			FAILURE:
				succes_index = 0
				return FAILURE

	succes_index = 0
	return SUCCESS
