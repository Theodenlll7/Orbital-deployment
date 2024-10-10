class_name PlayerWeapon extends Weapon


func _process(delta) -> void:
	if weapon_resource.has_magazine:
		if !reloading and Input.is_action_just_pressed("reload"):
			reload()

	if !canAttack:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true

	elif !reloading and attack_pressed():
		if weapon_resource.has_magazine:
			if weapon_resource.ammo_in_magazine > 0:
				weapon_resource.ammo_in_magazine -= 1
				weapon_resource.magazine_changed.emit(weapon_resource.ammo_in_magazine)
				attack()
			elif Input.is_action_just_pressed("primary_action"):
				reload()
		elif weapon_resource.has_ammo and weapon_resource.ammo > 0:
			weapon_resource.ammo -= 1
			weapon_resource.magazine_changed.emit(weapon_resource.ammo)
			attack()
		else:
			attack()

func get_bullet_damage() -> int:
	return int(weapon_resource.bullet_damage * PlayerSkillsManager.bullet_damage_scaler)

func attack_pressed() -> bool:
	return (
		(
			weapon_resource.attack_mode == WeaponResource.AttackMode.AUTOMATIC
			and Input.is_action_pressed("primary_action")
		)
		or (
			weapon_resource.attack_mode == WeaponResource.AttackMode.SINGLE
			and Input.is_action_just_pressed("primary_action")
		)
	)
