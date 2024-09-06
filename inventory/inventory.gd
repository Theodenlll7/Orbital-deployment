extends Node

class_name Inventory

var weapon_slots: Array = [null, null]
var util_slots: Array = [null, null]
var ability_slot: Node = null #TODO Replace node with the correct class_name

var selected_weapon_slot = 0

func add_weapon(weapon):
	var empty_slot = weapon_slots.find(null)
	if empty_slot:
		weapon_slots[empty_slot] = weapon
	else:
		drop_item(weapon_slots[selected_weapon_slot])
		weapon_slots[selected_weapon_slot] = weapon

func drop_item(item):
	pass
