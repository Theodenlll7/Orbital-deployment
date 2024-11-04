class_name URLButton
extends Button

# Exported variable to set the URL in the editor
@export var url: String = "https://example.com"

# Called when the button is pressed
func _on_button_pressed() -> void:
	if url:
		# Opens the URL in the default web browseropen url
		OS.shell_open(url)

# Connect the button's "pressed" signal to the function
func _ready() -> void:
	pressed.connect(_on_button_pressed)
