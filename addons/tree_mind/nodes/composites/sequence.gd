class_name Sequance extends MindTreeTask

var succes_index = 0


func tick(blackboard: Blackboard) -> int:
	var c = get_child(succes_index)
	if succes_index == get_child_count() - 1:
		return c.tick(blackboard)
	elif c.tick(blackboard) == RUNNING:
		return RUNNING
	elif c.tick(blackboard) == SUCCESS:
		succes_index += 1
		return RUNNING
	return FAILURE
