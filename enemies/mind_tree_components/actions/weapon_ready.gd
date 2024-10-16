class_name WeaponReady extends MTAction

@export var weapon: MobWeapon

func tick(_blackboard: Blackboard) -> int:
	if weapon.can_attack:
		return SUCCESS
	return FAILURE
