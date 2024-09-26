extends Node

var missions: Dictionary = {}

func _ready() -> void:
	# Initialize missions
	missions[1] = MissionData.new(1, "Mission 1", "This is the first mission.", "res://scenes/level_thumbnails/1id_thumbnail_mission.png", Vector2(-20, -200))
	missions[2] = MissionData.new(2, "Mission 2", "This is the second mission.", "res://scenes/level_thumbnails/2id_thumbnail_mission.png", Vector2(100, 100))

# Function to get a mission by ID
func get_mission_by_id(id: int) -> MissionData:
	return missions.get(id, null)  # Returns null if the mission doesn't exist
