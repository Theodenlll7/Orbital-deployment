extends Node
class_name Explosive

var explosive_name: String = ""
var explosive_cost: int = 0
var explosive_damage: float = 100.0 

@export var explosive_type: String = ""

@export var explosive_texture_icon: Texture  # Texture associated with the weapon 

func _init(
		new_explosive_name: String = "", 
		new_explosive_cost: int = 0, 
		new_explosive_damage: float = 100.0, 
		new_explosive_type: String = ""
	) -> void:
	explosive_name = new_explosive_name
	explosive_cost = new_explosive_cost
	explosive_damage = new_explosive_damage
	explosive_type = new_explosive_type

func explode() -> void:
	print(explosive_name, " exploded with damage: ", explosive_damage)
