
class_name MissionData

var id: int
var title: String
var description: String
var image_path: String
var marker_offset: Vector2

func _init(id: int,title: String, description: String, image_path: String, marker_offset: Vector2) -> void:
	self.id = id
	self.title = title
	self.description = description
	self.image_path = image_path
	self.marker_offset = marker_offset
