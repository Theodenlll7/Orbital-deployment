class_name TargetInRange extends MTCondition

@export var reach_distance = 25


func tick(blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target") as Node
	if target:
		var distance = target.global_position.distance_to(blackboard.actor.global_position)
		if distance <= reach_distance:
			return SUCCESS
	return FAILURE
