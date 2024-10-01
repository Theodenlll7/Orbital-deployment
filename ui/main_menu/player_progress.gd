extends Control

@onready var level_label: Label = $LevelMarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var progress_bar: ProgressBar = $LevelMarginContainer/Panel/MarginContainer/VBoxContainer/ProgressBar
@onready var progress_label: Label = $LevelMarginContainer/Panel/MarginContainer/VBoxContainer/ProgressBar/ProgressLabel
@onready var back_button: Button = $ContentMarginContainer/BackButton

signal back_to_main_menu

func _ready() -> void:
	visible = false
	handle_connecting_signals()
	set_progress()

func set_progress() -> void:
	var current_level = ExperiencePoints.get_current_level()
	var current_experience = ExperiencePoints.get_experience_points()
	var experience_needed = ExperiencePoints.experience_needed
	
	progress_bar.value = current_experience
	progress_bar.max_value = experience_needed
	level_label.text = " " + str(current_level)
	progress_label.text = str(current_experience) + " / " + str(experience_needed)

func on_back_button_pressed() -> void:
	back_to_main_menu.emit()

	
func handle_connecting_signals() -> void:
	back_button.button_down.connect(on_back_button_pressed)
