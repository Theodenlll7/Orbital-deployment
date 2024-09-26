class_name UntilFailure extends MTDecorator


func tick(blackbord: Blackboard):
	if child.tick(blackbord) != FAILURE:
		return RUNNING
	else:
		return FAILURE
