class_name StartAttackingTarget extends MTAction


func tick(blackboard: Blackboard) -> int:
	var weapon := blackboard.actor.get_node("MobWeapon") as MobWeapon
	assert(weapon, "Actor has no MobWeapon")
	var target = blackboard.get_value("target")
	if !target:
		return FAILURE
	weapon.set_target(target)
	weapon.start_attacking()
	return SUCCESS
