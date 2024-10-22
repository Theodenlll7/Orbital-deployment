class_name Inventory extends Node

signal money_changed(new_money_amount: int)
var money: int = 0:
	get:
		return money
	set(value):
		money = value
		money_changed.emit(money)

@export var weapon_slots: Array[WeaponResource] = [null, null]
@export var explosive_slot: ExplosiveResource = null
@export var special_equipment_slot: SpecialEquipment = null
@export var end_of_wave_money_bonus: int = 0

var actor: Node2D

@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager

var selected_weapon_slot = -1
var signal_emitter

##Triggers when the selected weapon slot changes to a new slot
signal weapon_swap(index: int, weapon: WeaponResource)
signal new_weapon(index: int, weapon: WeaponResource)
signal new_explosive(explosive: ExplosiveResource)


func setup() -> void:
	wave_manager.end_of_wave.connect(add_wave_money_bonus)
	for i in range(weapon_slots.size()):
		if weapon_slots[i]:
			new_weapon.emit(i, weapon_slots[i])
			if selected_weapon_slot == -1:
				select_weapon_slot(i)

	if explosive_slot:
		new_explosive.emit(explosive_slot)
	new_explosive.connect(_new_explosive)


func add_wave_money_bonus(_time_until_next_wave: float) -> void:
	money += end_of_wave_money_bonus


func add_weapon(weapon: WeaponResource):
	if weapon:
		var empty_slot = weapon_slots.find(null)
		if empty_slot != -1:
			weapon_slots[empty_slot] = weapon
			new_weapon.emit(empty_slot, weapon)
			select_next_slot()
		else:
			drop_item(weapon_slots[selected_weapon_slot])
			weapon_slots[selected_weapon_slot] = weapon
			new_weapon.emit(selected_weapon_slot, weapon)
			select_weapon_slot(selected_weapon_slot)


func _new_explosive(explosive: ExplosiveResource) -> void:
	if explosive:
		explosive.explosive_thrown.connect(_explosive_thrown)


func _explosive_thrown(explosive: ExplosiveResource) -> void:
	if explosive == explosive_slot:
		if explosive.explosive_count <= 0:
			set_explosive(null)


func set_explosive(explosive: ExplosiveResource):
	explosive_slot = explosive
	new_explosive.emit(explosive)


func add_special_equipment(special_equipment):
	special_equipment_slot = special_equipment


func drop_item(_item):
	pass


func add_ammo():
	var weapon = weapon_slots[selected_weapon_slot]
	weapon.ammo_create_picked_up()


#Coming from shop with the help of a signal
func pickup(item):
	if item is WeaponResource:
		add_weapon(item)
	elif item is ExplosiveResource:
		set_explosive(item)
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
			weapon_swap.emit(slot, weapon_slots[slot])
			selected_weapon_slot = slot
