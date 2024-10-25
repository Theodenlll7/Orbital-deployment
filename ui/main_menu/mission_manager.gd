extends Node

var missions: Dictionary = {}
var missions_paths: Dictionary = {}


func _ready() -> void:
	# Initialize missions
	missions["2"] = MissionData.new(2, "Lost signal", "An isolated island, plagued by failed experiments and strange, hostile creatures.", "res://scenes/level_thumbnails/1id_thumbnail_mission.png", Vector2(-20, -200))
	missions["3"] = MissionData.new(1, "Road of sacrifice", "A haunting landscape of ancient sacrifices and weathered stone pillars draped in sea mist.", "res://scenes/level_thumbnails/2id_thumbnail_mission.png", Vector2(100, 80))
	missions["5"] = MissionData.new(3, "Walls in darkness", "A foreboding castle labyrinth shrouded in darkness and mystery.", "res://scenes/level_thumbnails/3id_thumbnail_mission.png", Vector2(-280, 20))
	missions["4"] = MissionData.new(4, "Neptune", "Vast waters conceal secrets of the past and echoes of combat.", "res://scenes/level_thumbnails/4id_thumbnail_mission.png", Vector2(-380, -50))
	missions["1"] = MissionData.new(1, "Unknown regions", "The Unknown Regions are a dense, mysterious forest filled with shadowy paths and hidden dangers.", "res://scenes/level_thumbnails/5id_thumbnail_mission.png", Vector2(80, -60))


	missions_paths["infinite"] = "res://scenes/world.tscn"
	missions_paths["2"] = "res://scenes/level1.tscn"
	missions_paths["3"] = "res://scenes/level2.tscn"
	missions_paths["5"] = "res://scenes/level3.tscn"
	missions_paths["4"] = "res://scenes/level4.tscn"
	missions_paths["1"] = "res://scenes/level5.tscn"


func getMissionName(id: String) -> String:
	var mission = missions.get(id, null)
	if !mission:
		return "";
		
	return mission.title

# Function to get a mission by ID
func get_mission_by_id(id: String) -> MissionData:
	return missions.get(id, "")  # Returns "" if the mission doesn't exist

func get_mission_path_by_id(id: String) -> String:
	return missions_paths.get(id, "")
	
