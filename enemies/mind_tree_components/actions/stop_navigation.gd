class_name StopNavgation extends MTAction


func tick(blackboard: Blackboard) -> int:
	var navigator = blackboard.actor.get_node("Navigator2D") as Navigator2D
	assert(navigator, "Actor has no Navigator2D")
	navigator.stop_navigation()
	return SUCCESS
