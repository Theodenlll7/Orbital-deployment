extends CanvasLayer

class_name PlayerHUD

@export_group("Weapon Slots")
@export var weapon_slots : Array[AspectRatioContainer] = [null, null]
@export var selected_size : float = 1
@export var deselected_size : float = 0.5

var selected_slot = -1

func _ready() -> void:
	for weapon_slot in weapon_slots.size():
		select_weapon_slot(weapon_slot)
	deselect_weapon_slot(0)

func select_weapon_slot(index :int) -> void:
	weapon_slots[index].scale = Vector2(selected_size,selected_size)
	deselect_weapon_slot(selected_slot)
	selected_slot = index
	
func deselect_weapon_slot(index :int) -> void:
	if index < 0 or weapon_slots.size() < index: 
		return
	weapon_slots[index].scale = Vector2(deselected_size,deselected_size)
	
