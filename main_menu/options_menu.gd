class_name OptionsMenu
extends Control

@onready var back_button: Button = $ContentMarginContainer/BackButton

signal back_to_main_menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.button_down.connect(on_back_pressed)
	visible = false
	set_process(true)


func on_back_pressed() -> void:
	back_to_main_menu.emit()
