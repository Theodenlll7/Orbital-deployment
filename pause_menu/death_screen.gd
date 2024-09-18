
extends Control
class_name  DeathScreen
@onready var back_to_menu_button: Button = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/BackToMenuButton
@onready var background_color_rect: ColorRect = $TextureRect/BackgroundColorRect
@onready var death_label: Label = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect/VBoxContainer/Control/DeathLabel
@onready var progress_labels: HBoxContainer = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect/VBoxContainer/ColorRect/MarginContainer/ProgressLabels
@onready var text_background_color_rect: ColorRect = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect

@onready var main_menu = load("res://main_menu/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()
	
	var opacity = 0.0
	background_color_rect.color.a = opacity
	text_background_color_rect.color.a = opacity
	death_label.modulate.a = opacity
	progress_labels.modulate.a = opacity

func fade_in():
	visible = true
	var fade_time = 2.0 
	var fade_time_slow = 4.0
	var opacity = 1.0
	
	var tween = create_tween()
	tween.tween_property(background_color_rect, "color:a", opacity, fade_time_slow)
	tween.parallel().tween_property(death_label, "modulate:a", opacity, fade_time_slow)
	tween.parallel().tween_property(text_background_color_rect, "color:a", opacity, fade_time)
	tween.parallel().tween_property(progress_labels, "modulate:a", opacity, fade_time_slow)

func on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)


func handle_connecting_signals() -> void:
	back_to_menu_button.button_down.connect(on_back_to_menu_button_pressed)
