extends Node2D
class_name WeaponHand

var held_weapon: Weapon
# Called when the node enters the scene tree for the first time.

func equip_weapon(weapon : Weapon):
	if held_weapon:
		held_weapon.queue_free()
	held_weapon = weapon
	add_child(held_weapon)
