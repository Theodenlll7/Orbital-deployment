extends Control
@onready var back_to_menu_button: Button = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/BackToMenuButton
@onready var background_color_rect: ColorRect = $TextureRect/BackgroundColorRect
@onready var death_label: Label = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect/VBoxContainer/Control/DeathLabel
@onready var progress_labels: HBoxContainer = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect/VBoxContainer/ColorRect/MarginContainer/ProgressLabels
@onready var text_background_color_rect: ColorRect = $TextureRect/BackgroundColorRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/ColorRect

const MAIN_MENU = preload("res://main_menu/main_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var opacity = 0.0
	background_color_rect.color.a = opacity
	text_background_color_rect.color.a = opacity
	death_label.modulate.a = opacity
	progress_labels.modulate.a = opacity
	
	
	fade_in()

func fade_in():
	var fade_time = 2.0 
	var fade_time_slow = 4.0
	var opacity = 1.0
	
	var tween = create_tween()
	tween.tween_property(background_color_rect, "color:a", opacity, fade_time_slow)
	tween.parallel().tween_property(death_label, "modulate:a", opacity, fade_time_slow)
	tween.parallel().tween_property(text_background_color_rect, "color:a", opacity, fade_time)
	tween.parallel().tween_property(progress_labels, "modulate:a", opacity, fade_time_slow)

func on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	back_to_menu_button.button_down.connect(on_back_to_menu_button_pressed)
