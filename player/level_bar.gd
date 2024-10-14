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
	var experience_needed = ExperiencePoints.get_experience_needed_to_next_level()
	
	progress_bar.max_value = experience_needed
	progress_bar.value = current_experience
	level.text = "Level: " + str(current_level)
	progress_label.text = str(current_experience) + " / " + str(experience_needed)

func on_experience_updated() -> void:
	update_ui()
	
func update_weapon_pods(_level):
	var parent = get_parent().get_parent().get_parent().get_parent().get_parent()
	for child in parent.get_children():
		if child.name == "WeaponPod":
			var canvas_layer = child.get_node("CanvasLayer")
			var store_ui = canvas_layer.get_node("StoreUI")
			store_ui.update_weapons(level)
