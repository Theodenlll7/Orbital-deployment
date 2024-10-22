
class_name MissionData

var id: int
var title: String
var description: String
var image_path: String
var marker_offset: Vector2
var difficulty: String

func _init(new_id: int,new_title: String, new_description: String, new_image_path: String, new_marker_offset: Vector2) -> void:
	id = new_id
	title = new_title
	description = new_description
	image_path = new_image_path
	marker_offset = new_marker_offset
	
	if id < 3:
		difficulty = "Easy"
	elif id < 5:
		difficulty = "Medium"
	else:
		difficulty = "Hard"
