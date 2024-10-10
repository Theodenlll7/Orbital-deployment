extends Node

var missions: Dictionary = {}
var missions_paths: Dictionary = {}


func _ready() -> void:
	# Initialize missions
	missions["1"] = MissionData.new(1, "Mission 1", "This is the first mission.", "res://scenes/level_thumbnails/1id_thumbnail_mission.png", Vector2(-20, -200))
	missions["2"] = MissionData.new(2, "Mission 2", "This is the second mission.", "res://scenes/level_thumbnails/2id_thumbnail_mission.png", Vector2(100, 80))
	missions["3"] = MissionData.new(2, "Mission 3", "This is the third mission.", "res://scenes/level_thumbnails/3id_thumbnail_mission.png", Vector2(-280, 20))

	missions_paths["infinite"] = "res://scenes/world.tscn"
	missions_paths["1"] = "res://scenes/level1.tscn"
	missions_paths["2"] = "res://scenes/level2.tscn"
	missions_paths["3"] = "res://scenes/level3.tscn"

	

# Function to get a mission by ID
func get_mission_by_id(id: String) -> MissionData:
	return missions.get(id, null)  # Returns null if the mission doesn't exist

func get_mission_path_by_id(id: String) -> String:
	return missions_paths.get(id, null)
	
