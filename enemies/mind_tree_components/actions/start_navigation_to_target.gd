class_name StartNavgationToTarget extends MTAction

@export var move_speed: float = 150


func tick(blackboard: Blackboard) -> int:
	var navigator = blackboard.actor.get_node("Navigator2D") as Navigator2D
	assert(navigator, "Actor has no Navigator2D")
	var target_position = blackboard.get_value("target_position")
	if !target_position and blackboard.has_value("target"):
		target_position = blackboard.get_value("target").global_position

	return SUCCESS if navigator.start_navigation(target_position, move_speed) else FAILURE
