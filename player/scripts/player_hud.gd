extends CanvasLayer

class_name PlayerHUD

@export_group("Weapon Slots")
@export var weapon_slots: Array[AspectRatioContainer] = [null, null]
@export var selected_size: float = 1
@export var deselected_size: float = 0.5

@onready var ammo_indicator : AmmoIndicator = $PlayerHUD/AmmoIndicator

var selected_slot = -1

func _ready() -> void:
	for slot in weapon_slots.size():
		deselect_weapon_slot(slot)

func select_weapon_slot(index: int) -> void:
	weapon_slots[index].scale = Vector2(selected_size, selected_size)
	deselect_weapon_slot(selected_slot)
	selected_slot = index

func deselect_weapon_slot(index: int) -> void:
	if index < 0 or weapon_slots.size() < index:
		return
	weapon_slots[index].scale = Vector2(deselected_size, deselected_size)

func equip_weapon(slot_index: int, weapon: WeaponResource):
	var slot = weapon_slots[slot_index]
	var icon: TextureRect = slot.get_node("Icon")
	icon.texture = weapon.texture

func equip_explosive(explosive: ExplosiveResource):
	var slot = $PlayerHUD/HBoxContainer2.get_child(0).get_child(0)
	var icon: TextureRect = slot.get_node("Icon")
	icon.texture = explosive.texture
