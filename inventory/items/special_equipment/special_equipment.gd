extends Node
class_name SpecialEquipment

var equipment_name: String = ""
var equipment_cost: int = 0
var equipment_effect: String = ""  

@export var equipment_type: String = ""  

func _init(
		new_equipment_name: String = "", 
		new_equipment_cost: int = 0, 
		new_equipment_effect: String = "", 
		new_equipment_type: String = ""
	) -> void:
	equipment_name = new_equipment_name
	equipment_cost = new_equipment_cost
	equipment_effect = new_equipment_effect
	equipment_type = new_equipment_type

func use_equipment() -> void:
	print("Using ", equipment_name, " which provides effect: ", equipment_effect)
