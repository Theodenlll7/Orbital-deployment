extends Node2D

@onready var interaction_area := $InteractionArea
@onready var houseUI := $CanvasLayer
@onready var Store := $CanvasLayer/StoreUI

@export var pod_type = ""

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	houseUI.hide()
	Store.setLabelsAndCost(Store.loadResource(pod_type))

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


func _on_interaction_area_body_exited(body) -> void:
	if body.is_in_group("players"):
		hideUI()
