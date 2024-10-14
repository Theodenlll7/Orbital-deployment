class_name AimWeapon extends MTAction

@export var weapon: MobWeapon


func tick(blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if target:
		weapon.aim(target)
		return SUCCESS
	return FAILURE
