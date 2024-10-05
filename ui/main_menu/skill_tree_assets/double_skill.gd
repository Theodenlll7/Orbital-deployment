extends Control

@onready var label: Label = $VBoxContainerLabel/Label

@onready var texture_button_top: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonTop
@onready var texture_button_bottom: TextureButton = $VBoxContainerContent/HBoxContainer/VBoxContainer/TextureButtonBottom

var level: int = 0

func set_texture(img_dict: Dictionary) -> void:
	var normal_texture: Texture2D = load(img_dict["normal"])
	var hover_texture: Texture2D = load(img_dict["hover"])
	var disabled_texture: Texture2D = load(img_dict["disabled"])
	
	texture_button_top.texture_normal = normal_texture
	texture_button_top.texture_hover = hover_texture
	texture_button_top.texture_disabled = disabled_texture
	
	texture_button_bottom.texture_normal = normal_texture
	texture_button_bottom.texture_hover = hover_texture
	texture_button_bottom.texture_disabled = disabled_texture

func set_level(new_level: int) -> void:
	level = new_level
	label.text = "Level " + str(level)
