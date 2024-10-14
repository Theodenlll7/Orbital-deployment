@tool
@icon("../../icons/sequance.svg")

## A seqance that starts from the begining until all succeds or any node fails (be carfule infinity loop possible)
class_name RepetingSequance extends Composite

var succes_index = 0


func tick(blackboard: Blackboard) -> int:
	for i in range(succes_index, get_child_count()):
		var c = get_child(i)
		var state = c.tick(blackboard)
		match state:
			RUNNING:
				succes_index = 0
				return RUNNING
			SUCCESS:
				succes_index += 1
			FAILURE:
				succes_index = 0
				return FAILURE

	succes_index = 0
	return SUCCESS
