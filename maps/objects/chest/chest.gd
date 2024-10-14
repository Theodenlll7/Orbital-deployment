extends Node2D

@onready var interaction_area := $InteractionArea
@export var chest_value = 100

func _ready() -> void:
	interaction_area.interact = _on_interact


func _on_interact(_player : Player):
	SoundEngine.playChestSound()
	GenerateMapVariables._on_chest_picked_up(self)
	var inventory = _player.get_node("Inventory")
	if inventory:
		inventory.money +=chest_value
	queue_free()
