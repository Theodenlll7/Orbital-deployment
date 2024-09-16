extends Node

class_name Inventory

var weapon_slots: Array[Weapon] = [null, null]
var explosive_slot = Explosive
var special_equipment_slot: SpecialEquipment = null

var selected_weapon_slot = 0
var signal_emitter

@export var player_hud : PlayerHUD = null

@onready var hand := $"../WeaponHand"

func _ready():
	signal_emitter = get_node("/root/Shop")
	if signal_emitter:
		signal_emitter.connect("purchase_made", Callable(self, "_on_purchase_made"))

func add_weapon(weapon):
	var empty_slot = weapon_slots.find(null)
	if empty_slot!=-1:
		weapon_slots[empty_slot] = weapon
		setPlayerInventoryImage(empty_slot+1, weapon.weapon_texture_icon)
	else:
		drop_item(weapon_slots[selected_weapon_slot])
		weapon_slots[selected_weapon_slot] = weapon
		setPlayerInventoryImage(selected_weapon_slot, weapon.weapon_texture_icon)

func add_explosive(explosive):
	explosive_slot = explosive
	setPlayerInventoryImage(3, explosive.explosive_texture_icon)

func add_special_equipment(special_equipment):
	special_equipment_slot = special_equipment
	setPlayerInventoryImage(4, special_equipment.explosive_texture_icon)

func drop_item(item):
	pass

#Change a sprite image when you change weapon
func setPlayerInventoryImage(slot, image):
	if image:
		self.get_child(slot).texture = image
	else:
		print("Icon texture not found")

#Coming from shop with the help of a signal
func _on_purchase_made(item):
	if item is Weapon:
		print("Purchased Weapon: ", item.weapon_name, " | Cost: ", item.weapon_cost)
		add_weapon(item)
	elif item is Explosive:
		print("Purchased Explosive: ", item.explosive_name, " | Cost: ", item.explosive_cost, " | Damage: ", item.explosive_damage, " | Type: ", item.explosive_type)
		add_weapon(item)
	elif item is SpecialEquipment:
		print("Purchased Special Equipment: ", item.equipment_name, " | Cost: ", item.equipment_cost, " | Effect: ", item.equipment_effect, " | Type: ", item.equipment_type)
	else:
		print("Unknown item type: ", item)

func select_next_slot() -> void:
	if weapon_slots.size() > 0:
		selected_weapon_slot = (selected_weapon_slot + 1) % weapon_slots.size()
		player_hud.select_weapon_slot(selected_weapon_slot)
		hand.equip_weapon(weapon_slots[selected_weapon_slot])
