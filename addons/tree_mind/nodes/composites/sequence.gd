class_name Sequance extends Composite

var succes_index = 0

func tick(blackboard: Blackboard) -> int:
	for i in range(succes_index, get_child_count()):
		var c = get_child(i)
		if succes_index == get_child_count() - 1:
			return c.tick(blackboard)
		elif c.tick(blackboard) == RUNNING:
			return RUNNING
		elif c.tick(blackboard) == SUCCESS:
			succes_index += 1
		else:
			break
	succes_index = 0
	return FAILURE
