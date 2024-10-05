extends Node2D

@onready var interaction_area := $InteractionArea
@onready var storeUI := $CanvasLayer/StoreUI as PodShop
@onready var Store : PodShop = $CanvasLayer/StoreUI

@export var pod_type = ""

var costumer: Player

func _ready() -> void:
	interaction_area.interact = _on_interact
	storeUI.hide()
	set_pod_type(pod_type)

func set_pod_type(new_pod_type):
	match new_pod_type:
		"weapon":
			Store.setLabelsAndCost(PodShop.ShopType.weapon)
		"explosive":
			Store.setLabelsAndCost(PodShop.ShopType.explosive)
			
			
func _on_interact(player : Player):
	showUI(player)

func showUI(player : Player):
	storeUI.show()
	storeUI.costumer = player.inventory


func hideUI():
	storeUI.hide()
	storeUI.costumer = null


func _input(event: InputEvent) -> void:
	# Check if the event is a key press and if it's the ESC key
	if event.is_action_pressed("ui_cancel"):
		# Hide the UI when ESC is pressed
		if storeUI.visible:
			hideUI()


func _on_interaction_area_body_exited(body) -> void:
	if body.is_in_group("players"):
		hideUI()
