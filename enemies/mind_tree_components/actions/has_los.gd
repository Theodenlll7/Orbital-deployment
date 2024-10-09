class_name HasLoS extends MTCondition

func tick(blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	var actor = blackboard.actor

	if target and actor:
		var space_state = actor.get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(actor.global_position, target.global_position,
		32, [self])
		var result = space_state.intersect_ray(query)
		# Update the ray and check for collisions
		if result.is_empty():
			print("Has_LoS")
			return SUCCESS # Clear line of sight
	return FAILURE
