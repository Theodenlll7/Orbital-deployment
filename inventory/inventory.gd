class_name Inventory

signal money_changed(new_money_amount: int)
var money: int = 1000:
	get:
		return money
	set(value):
		money = value
		money_changed.emit(money)
		print("Player money has been updated: ", money)

var weapon_slots: Array[WeaponResource] = [null, null]
var explosive_slot = ExplosiveResource
var special_equipment_slot: SpecialEquipment = null

var actor: Node2D

var selected_weapon_slot = -1
var signal_emitter

##Triggers when the selected weapon slot changes to a new slot
signal weapon_swap(index: int, weapon: WeaponResource)
signal new_weapon(index: int, weapon: WeaponResource)
signal new_explosive(index: int, explosive: ExplosiveResource)


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


func add_explosive(explosive):
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
		add_explosive(item)
		new_explosive.emit(item)
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
