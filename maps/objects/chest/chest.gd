extends Node2D

@onready var interaction_area := $InteractionArea


func _ready() -> void:
	interaction_area.interact = _on_interact


func _on_interact(player : Player):
	SoundEngine.playChestSound()
	GenerateMapVariables._on_chest_picked_up(self)
	queue_free()


func _on_interaction_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
