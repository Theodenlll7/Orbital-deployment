extends HBoxContainer

@onready var level: Label = $HBoxContainer/Level
@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar
@onready var progress_label: Label = $MarginContainer/ProgressBar/ProgressLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ExperiencePoints.connect("experience_updated", Callable(self, "on_experience_updated"))
	update_ui()

func update_ui() -> void:
	var current_level = ExperiencePoints.get_current_level()
	var current_experience = ExperiencePoints.get_experience_points()
	var experience_needed = ExperiencePoints.experience_needed
	
	progress_bar.value = current_experience
	progress_bar.max_value = experience_needed
	level.text = "Level: " + str(current_level)
	progress_label.text = str(current_experience) + " / " + str(experience_needed)

func on_experience_updated() -> void:
	update_ui()
