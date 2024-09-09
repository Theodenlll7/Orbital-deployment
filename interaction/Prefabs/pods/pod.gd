extends Node2D

@onready var interaction_area := $InteractionArea
@onready var houseUI := $CanvasLayer

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact") 
	
	# Initially hide the UI
	houseUI.hide()

func _on_interact():
	showUI()

func showUI():
	houseUI.show()

func hideUI():
	houseUI.hide()

func _input(event: InputEvent) -> void:
	# Check if the event is a key press and if it's the ESC key
	if event.is_action_pressed("ui_cancel"):
		# Hide the UI when ESC is pressed
		if houseUI.visible:
			hideUI()
