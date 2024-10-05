extends Control

@onready var label: Label = $VBoxContainerLabel/Label

@onready var texture_button: TextureButton = $VBoxContainerContent/HBoxContainer/TextureButton
var level: int = 0

func set_texture(img_dict: Dictionary) -> void:
	var normal_texture: Texture2D = load(img_dict["normal"])
	var hover_texture: Texture2D = load(img_dict["hover"])
	var disabled_texture: Texture2D = load(img_dict["disabled"])
	
	texture_button.texture_normal = normal_texture
	texture_button.texture_hover = hover_texture
	texture_button.texture_disabled = disabled_texture

func set_level(new_level: int) -> void:
	level = new_level
	label.text = "Level " + str(level)
