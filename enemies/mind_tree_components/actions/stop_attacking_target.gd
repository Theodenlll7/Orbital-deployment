class_name StopAttacking extends MTAction


func tick(blackboard: Blackboard) -> int:
	var weapon = blackboard.actor.get_node_or_null("MobWeapon") as MobWeapon
	assert(weapon, "Actor has no MobWeapon")
	weapon.stop_attacking()
	return SUCCESS
