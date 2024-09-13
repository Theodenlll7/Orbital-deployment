extends CanvasLayer

@export_group("Weapon Slots")
@export var weapon_slots : Array[AspectRatioContainer] = [null, null]
@export var selected_size : float = 1
@export var deselected_size : float = 0.5

var selected_slot = -1

func _ready() -> void:
	select_weapon(0)
	deselect_weapon(1)

func select_weapon(index :int) -> void:
	weapon_slots[index].scale = Vector2(selected_size,selected_size)
	deselect_weapon(selected_slot)
	selected_slot = index
	
func deselect_weapon(index :int) -> void:
	if index < 0: 
		return
	weapon_slots[index].scale = Vector2(deselected_size,deselected_size)
	
