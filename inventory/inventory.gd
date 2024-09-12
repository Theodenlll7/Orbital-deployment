extends Node

class_name Inventory

var weapon_slots: Array = [null, null]
var util_slot = null
var ability_slot: Node = null #TODO Replace node with the correct class_name

var selected_weapon_slot = 0

var signal_emitter

func _ready():
	signal_emitter = get_node("/root/Shop")
	if signal_emitter:
		signal_emitter.connect("purchase_made", Callable(self, "_on_purchase_made"))
	
func add_weapon(weapon):
	var empty_slot = weapon_slots.find(null)
	if empty_slot:
		weapon_slots[empty_slot] = weapon
	else:
		drop_item(weapon_slots[selected_weapon_slot])
		weapon_slots[selected_weapon_slot] = weapon

func add_util(util):
	util_slot = util


func drop_item(item):
	pass

func setPlayerInventoryImage(slot, image):
	self.get_child(slot).Texture = image

func _on_purchase_made(name):
	print("signal to inventory made", name)
