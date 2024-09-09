extends Node2D

@onready var interaction_area := $InteractionArea
signal chest_picked_up

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact") 

func _on_interact():
	print("Interaction/interactionarea.gd")
	SoundEngine.playChestSound()
	emit_signal("chest_picked_up", self)
	queue_free()
