class_name MissionInfoPanel
extends PanelContainer

@onready var mission_title_label: RichTextLabel = $MarginContainer/VBoxContainer/Title
@onready var mission_description_label: RichTextLabel = $MarginContainer/VBoxContainer/Description
@onready var difficulty_label: RichTextLabel =$MarginContainer/VBoxContainer/Difficulty
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/MarginContainer/Thumbnail


func set_mission(mission: MissionData):
	mission_title_label.text = mission.title
	mission_description_label.text = mission.description
	
	var difficulty_color: String = ""
	match mission.difficulty:
		"Easy":
			difficulty_color = "green"
		"Medium":
			difficulty_color = "yellow"
		"Hard":
			difficulty_color = "red"

	difficulty_label.text = "Difficulty: [color= " + difficulty_color + "]" + mission.difficulty + "[/color]"
	
	var new_texture = load(mission.image_path) as Texture2D
	texture_rect.texture = new_texture
