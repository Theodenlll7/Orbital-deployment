extends Node

class_name Inventory

@export var weapon_slots: Array[WeaponResource] = [null, null]
@export var explosive_slot = ExplosiveResource
@export var special_equipment_slot: SpecialEquipment = null

var selected_weapon_slot = -1
var signal_emitter

@export var player_hud: PlayerHUD = null

@onready var player: Player = get_parent()


func _ready():
	signal_emitter = get_node("/root/Shop")
	if signal_emitter:
		signal_emitter.connect("purchase_made", Callable(self, "_on_purchase_made"))
	init_inventory()


func init_inventory():
	await get_tree().process_frame

	# Iterate through the weapon slots and equip them
	for i in range(weapon_slots.size()):
		if weapon_slots[i]:
			player_hud.equip_weapon(i, weapon_slots[i])
			if selected_weapon_slot == -1:
				select_weapon_slot(i)


func add_weapon(weapon: WeaponResource):
	var empty_slot = weapon_slots.find(null)
	if empty_slot != -1:
		weapon_slots[empty_slot] = weapon
		player_hud.equip_weapon(empty_slot, weapon)
		select_next_slot()
	else:
		drop_item(weapon_slots[selected_weapon_slot])
		weapon_slots[selected_weapon_slot] = weapon
		player_hud.equip_weapon(selected_weapon_slot, weapon)


func add_explosive(explosive):
	explosive_slot = explosive
	player_hud.equip_explosive(explosive)


func add_special_equipment(special_equipment):
	special_equipment_slot = special_equipment


func drop_item(_item):
	pass


func add_ammo():
	var weapon = weapon_slots[selected_weapon_slot]
	weapon.ammo_create_picked_up()
	if weapon.has_magazine:
		player_hud.ammo_indicator._on_ammo_changed(weapon.ammo_in_magazine, weapon.ammo)
	else:
		player_hud.ammo_indicator._on_magazine_changed(weapon.ammo)


#Coming from shop with the help of a signal
func _on_purchase_made(item):
	if item is WeaponResource:
		add_weapon(item)
	elif item is ExplosiveResource:
		add_explosive(item)
		player.equip_explosive(item)
	elif item is SpecialEquipment:
		print(
			"Purchased Special Equipment: ",
			item.equipment_name,
			" | Cost: ",
			item.equipment_cost,
			" | Effect: ",
			item.equipment_effect,
			" | Type: ",
			item.equipment_type
		)
	else:
		print("Unknown item type: ", item)


func select_next_slot() -> void:
	if weapon_slots.size() > 0:
		var next_slot = (selected_weapon_slot + 1) % weapon_slots.size()
		select_weapon_slot(next_slot)


func select_weapon_slot(slot: int):
	if slot >= 0 and slot < weapon_slots.size():
		if weapon_slots[slot]:
			player_hud.select_weapon_slot(slot)
			var weapon = player.equip_weapon(weapon_slots[slot])
			selected_weapon_slot = slot
			player_hud.ammo_indicator.equip_weapon(weapon)
