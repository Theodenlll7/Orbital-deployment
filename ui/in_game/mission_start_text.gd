extends Control

@onready var color_rect: ColorRect = $MarginContainer/VBoxContainer/MarginContainer/ColorRect
@onready var ship_destroyed_label: Label = $MarginContainer/VBoxContainer/MarginContainer/ContentMarginContainer/VBoxContainer/ShipDestroyedLabel
@onready var mission_label: Label = $MarginContainer/VBoxContainer/MarginContainer/ContentMarginContainer/VBoxContainer/HBoxContainer/MissionLabel
@onready var as_long_label: Label = $MarginContainer/VBoxContainer/MarginContainer/ContentMarginContainer/VBoxContainer/HBoxContainer/AsLongLabel
@onready var survive_label: Label = $MarginContainer/VBoxContainer/MarginContainer/ContentMarginContainer/VBoxContainer/HBoxContainer/SurviveLabel

var first_fade_duration: float = 2.5  # Duration for the first 3 labels to fade
var second_fade_duration: float = 0.5  # Duration for the last label to fade
var fade_time_passed: float = 0.0  # Tracks time for fade

var fading_first_group: bool = true  # Fading the first 3 labels
var fading_last_label: bool = false  # Fading the last label

func _ready() -> void:
	# Set initial opacity to 1.0 (fully visible)
	color_rect.modulate.a = 1.0
	ship_destroyed_label.modulate.a = 1.0
	mission_label.modulate.a = 1.0
	as_long_label.modulate.a = 1.0
	survive_label.modulate.a = 1.0

func _process(delta: float) -> void:
	fade_time_passed += delta

	if fading_first_group:
		# Fade the first 3 labels over the first 3 seconds
		var new_opacity = 1.0 - (fade_time_passed / first_fade_duration)
		new_opacity = clamp(new_opacity, 0.0, 1.0)

		# Apply opacity to the first 2 labels
		color_rect.modulate.a = new_opacity
		ship_destroyed_label.modulate.a = new_opacity
		mission_label.modulate.a = new_opacity
		as_long_label.modulate.a = new_opacity

		# If the first fade is done (3 seconds), stop fading them and start the next fade
		if fade_time_passed >= first_fade_duration:
			fading_first_group = false  # Stop fading first group
			fading_last_label = true  # Start fading the last label
			fade_time_passed = 0.0  # Reset the fade time for the second fade

	elif fading_last_label:
		# Fade the last label over the next 3 seconds
		var new_opacity = 1.0 - (fade_time_passed / second_fade_duration)
		new_opacity = clamp(new_opacity, 0.0, 1.0)

		# Apply opacity to the last label
		survive_label.modulate.a = new_opacity

		# If the last fade is done, hide all labels
		if fade_time_passed >= second_fade_duration:
			fading_last_label = false
			hide()
