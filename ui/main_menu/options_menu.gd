class_name OptionMenu
extends Control

@onready var back_button: Button = $BackButton

signal back_to_main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.button_down.connect(on_back_pressed)
	visible = false
	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible:
		(
			$settings_tab_container
			. get_tab_bar()
			. grab_focus()
		)


func on_back_pressed() -> void:
	back_to_main_menu.emit()
