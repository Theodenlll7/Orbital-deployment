extends Node2D
class_name WeaponHand

var held_weapon: Weapon = null
# Called when the node enters the scene tree for the first time.


func equip_weapon(weapon: WeaponResource):
	if held_weapon:
		held_weapon.queue_free()
	held_weapon = Weapon.new(weapon)
	add_child(held_weapon)
