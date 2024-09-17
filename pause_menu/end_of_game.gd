extends Control

@onready var back_to_menu_button: Button = $TextureRect/MarginContainer/VBoxContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/BackToMenuButton

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	back_to_menu_button.button_down.connect(on_back_to_menu_button_pressed)
