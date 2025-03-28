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
@onready var button_menu: VBoxContainer = $TextureRect/MarginContainer/VBoxContentContainer/Buttons/MarginContainer/HBoxContainer/VBoxContainer
@onready var xp_gained: Label = $TextureRect/MarginContainer/VBoxContentContainer/Text/MarginContainer/HBoxContainer/Control/VBoxContainer/ColorRect/MarginContainer/ProgressLabels/XPGained
@onready var xp_at_start: int = ExperiencePoints.get_total_amount_of_experience_points()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	handle_connecting_signals()

	var opacity = 0.0
	background_color_rect.color.a = opacity
	text_background_color_rect.color.a = opacity
	death_label.modulate.a = opacity
	progress_labels.modulate.a = opacity


func fade_in():
	SaveData.save_player_data()
	TooltipHud.init_vars()
	wave_label.text = str(wave_manager.wave)
	xp_gained.text = str(ExperiencePoints.get_total_amount_of_experience_points() - xp_at_start)
	visible = true
	first_btn_focus_grab()
	
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

func first_btn_focus_grab() -> void:
	var first_btn = button_menu.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()

func handle_connecting_signals() -> void:
	try_again_button.button_down.connect(on_try_again_button_pressed)
	back_to_menu_button.button_down.connect(on_back_to_menu_button_pressed)
