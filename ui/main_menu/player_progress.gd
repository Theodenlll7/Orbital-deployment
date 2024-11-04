extends Control

@onready var level_label: Label = $HBoxContainer/LevelMarginContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var progress_label: Label = $HBoxContainer/LevelMarginContainer/Panel/MarginContainer/VBoxContainer/ProgressBarMain/ProgressLabel
@onready var back_button: Button = $HBoxContainer/BackButton
@onready var progress_bar: ProgressBar = $HBoxContainer/LevelMarginContainer/Panel/MarginContainer/VBoxContainer/ProgressBarMain
@onready var content_margin_container: MarginContainer = $ContentMarginContainer

signal back_to_main_menu

func _ready() -> void:
	visible = false
	handle_connecting_signals()

func set_progress() -> void:
	var current_level = ExperiencePoints.get_current_level()
	var current_experience = ExperiencePoints.get_experience_points()
	var experience_needed = ExperiencePoints.get_experience_needed_for_next_level()

	progress_bar.max_value = experience_needed
	progress_bar.value = current_experience
	
	level_label.text = " " + str(current_level)
	progress_label.text = str(current_experience) + " / " + str(experience_needed)

func on_back_button_pressed() -> void:
	back_to_main_menu.emit()

func handle_connecting_signals() -> void:
	set_progress()
	back_button.button_down.connect(on_back_button_pressed)
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))

func on_experience_updated() -> void:
	set_progress()
