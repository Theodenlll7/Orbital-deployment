extends Control

@onready var level_label: Label = $LevelMarginContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/HBoxContainer/LevelLabel
@onready var progress_label: Label = $LevelMarginContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ProgressBarMain/ProgressLabel
@onready var back_button: Button = $ContentMarginContainer/BackButton
@onready var progress_bar: ProgressBar = $LevelMarginContainer/HBoxContainer/Panel/MarginContainer/VBoxContainer/ProgressBarMain
@onready var pop_up_reset_button: Button = $LevelMarginContainer/HBoxContainer/ResetPanel/PopUpResetButton
@onready var reset_margin_container: MarginContainer = $ResetMarginContainer
@onready var close_reset_pop_up_button: Button = $ResetMarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/CloseResetPopUpButton
@onready var reset_button: Button = $ResetMarginContainer/Panel/MarginContainer/HBoxContainer/HBoxContainer/ResetButton
@onready var skill_tree: Control = $ContentMarginContainer/MarginContainer/VBoxContainer/Panel/skill_tree

@onready var dev_button: Button = $DevButton
@onready var dev_button_2: Button = $DevButton2

signal back_to_main_menu
signal reset_data

func _ready() -> void:
	visible = false
	reset_margin_container.visible = false
	handle_connecting_signals()

func set_progress() -> void:
	var current_level = ExperiencePoints.get_current_level()
	var current_experience = ExperiencePoints.get_experience_points()
	var experience_needed = ExperiencePoints.get_experience_needed_for_next_level()

	progress_bar.max_value = experience_needed
	progress_bar.value = current_experience
	
	level_label.text = " " + str(current_level)
	progress_label.text = str(current_experience) + " / " + str(experience_needed)

func on_pop_up_reset_button_pressed() ->void:
	reset_margin_container.visible = true

func on_close_reset_pop_up_button_pressed() -> void:
	reset_margin_container.visible = false
	
func on_back_button_pressed() -> void:
	back_to_main_menu.emit()

func reset_progression() -> void:
	SaveData.reset_player_data()
	skill_tree.init_skill_tree()
	set_progress()

func dev() -> void:
	ExperiencePoints.add_experience(2000)
	SaveData.save_player_data()
	SaveData.load_player_data()
	
func dev2() -> void:
	ExperiencePoints.add_experience(1000)
	SaveData.reset_player_data()

func handle_connecting_signals() -> void:
	pop_up_reset_button.button_down.connect(on_pop_up_reset_button_pressed)
	close_reset_pop_up_button.button_down.connect(on_close_reset_pop_up_button_pressed)
	reset_button.button_down.connect(reset_progression)
	back_button.button_down.connect(on_back_button_pressed)
	set_progress()
	dev_button.button_down.connect(dev)
	dev_button_2.button_down.connect(dev2)
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))

func on_experience_updated() -> void:
	set_progress()
