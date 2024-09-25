class_name MoveToTargetPosition2D extends MindTreeTask

func tick(blackboard: Blackboard) -> int:
	var actor := blackboard.actor as CharacterBody2D
	assert(actor, "Null or Invalid actor, actor need to be of type CharacterBody2D")
	
	var nav_agent = blackboard.actor.get_node("NavigationAgent2D") as NavigationAgent2D
	assert(nav_agent, "Actor has no NavigationAgent2D")
	
	nav_agent.target_position = blackboard.get_value("target_position")
	var current_agent_position = blackboard.actor.global_position
	var next_path_position = nav_agent.get_next_path_position()
	actor.velocity = current_agent_position.direction_to(next_path_position)

	actor.move_and_slide()
	
	if nav_agent.is_target_reached():
		return SUCCESS
	elif nav_agent.get_final_position().distance_to(nav_agent.target_position) < nav_agent.target_desired_distance:
		return FAILURE
	else:
		return RUNNING
