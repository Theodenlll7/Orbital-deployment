extends Control
class_name DeathScreen

@onready var back_to_menu_button: Button = $TextureRect/MarginContainer/VBoxContentContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/BackToMenuButton
@onready var try_again_button: Button = $TextureRect/MarginContainer/VBoxContentContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer/TryAgainButton

@onready var background_color_rect: ColorRect = $TextureRect/BackgroundColorRect
@onready var death_label: Label = $TextureRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/VBoxContainer/Control/DeathLabel
@onready var progress_labels: HBoxContainer = $TextureRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/VBoxContainer/ColorRect/MarginContainer/ProgressLabels
@onready var text_background_color_rect: ColorRect = $TextureRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/VBoxContainer/Control/ColorRect
@onready var main_menu = load("res://ui/main_menu/main_menu.tscn")

@onready var wave_label: Label = $TextureRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/VBoxContainer/ColorRect/MarginContainer/ProgressLabels/Wave
@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()

	var opacity = 0.0
	background_color_rect.color.a = opacity
	text_background_color_rect.color.a = opacity
	death_label.modulate.a = opacity
	progress_labels.modulate.a = opacity


func fade_in():
	wave_label.text = str(wave_manager.wave)
	visible = true
	var fade_time = 2.0
	var fade_time_slow = 4.0
	var opacity = 1.0

	var tween = create_tween()
	tween.tween_property(background_color_rect, "color:a", opacity, fade_time_slow)
	tween.parallel().tween_property(death_label, "modulate:a", opacity, fade_time_slow)
	tween.parallel().tween_property(text_background_color_rect, "color:a", opacity, fade_time)
	tween.parallel().tween_property(progress_labels, "modulate:a", opacity, fade_time_slow)

func on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()

func on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)


func handle_connecting_signals() -> void:
	try_again_button.button_down.connect(on_try_again_button_pressed)
	back_to_menu_button.button_down.connect(on_back_to_menu_button_pressed)
