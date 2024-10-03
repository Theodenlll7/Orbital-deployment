extends MagneticItem
class_name AmmoCrate


func pick_up_condition() -> bool:
	var weapon = inventory.weapon_slots[inventory.selected_weapon_slot]
	return weapon and weapon.ammo < weapon.ammo_cap


func pick_up_item():
	inventory.add_ammo()
	queue_free()
