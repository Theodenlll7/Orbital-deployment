class_name Ammo extends Item

func pickup_condition(player: Player) -> bool:
	var weapon = player.inventory.weapon_slots[player.inventory.selected_weapon_slot]
	return weapon and weapon.ammo < weapon.ammo_cap


func pickup_item(player: Player) -> void:
	player.inventory.add_ammo()
