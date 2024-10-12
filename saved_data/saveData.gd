extends Node

var save_path_player_data = "user://player_data.bin"
const save_path_key_bindings = "user://key_bindings.json"

var player_level = 2
var experience_points = 200
var tot_experience_points = 300
var skill_settings: Dictionary = {}


func save_player_data() -> void:
	player_level = ExperiencePoints.current_level
	experience_points = ExperiencePoints.experience_points
	tot_experience_points = ExperiencePoints.total_amount_of_experience_points
	
	var file = FileAccess.open(save_path_player_data, FileAccess.WRITE)
	file.store_var(player_level)
	file.store_var(experience_points)
	file.store_var(tot_experience_points)
	file.store_var(PlayerSkillsManager.skill_layout)
	file.close()

func reset_player_data() -> void:
	var file = FileAccess.open(save_path_player_data, FileAccess.WRITE)
	file.store_var(1)
	file.store_var(0)
	file.store_var(0)
	file.store_var({})
	file.close()
	
	ExperiencePoints.current_level = 1
	ExperiencePoints.experience_points = 0
	ExperiencePoints.total_amount_of_experience_points = 0
	PlayerSkillsManager.skill_layout = PlayerSkillsManager.get_skill_layout()
	
func load_player_data() -> void:
	if FileAccess.file_exists(save_path_player_data):
		var file = FileAccess.open(save_path_player_data, FileAccess.READ)
		player_level = file.get_var()
		experience_points = file.get_var()
		tot_experience_points = file.get_var()
		var try_to_read_skill_settings = file.get_var()
		if try_to_read_skill_settings:
			skill_settings = try_to_read_skill_settings
		ExperiencePoints.current_level = player_level
		ExperiencePoints.experience_points = experience_points
		ExperiencePoints.total_amount_of_experience_points = tot_experience_points
		PlayerSkillsManager.skill_layout = skill_settings
	else:
		print("could not load data")

#func save_key_bindings() -> void:
	#var bindings_dict = {}
	#
	## Iterate through all input actions defined in the InputMap
	#for action in InputMap.get_actions():
		#var events = InputMap.action_get_events(action)
		#var event_codes = []
		#
		## Check each event linked to the action
		#for event in events:
			#if event is InputEventKey:
				## Add keyboard events
				#event_codes.append(event.as_text_physical_keycode())
			#elif event is InputEventMouseButton:
				## Add mouse events
				#event_codes.append(event.as_text())
		#
		#bindings_dict[action] = event_codes
	#
	#var file = FileAccess.open(save_path_key_bindings, FileAccess.WRITE)
	#var json = JSON.new()
	#
	#var json_string = json.stringify(bindings_dict)
	#file.store_string(json_string)
	#file.close()

#func load_key_bindings() -> void:
	#var file = FileAccess.open(save_path_key_bindings, FileAccess.READ)
	#if file == null:
		#print("Failed to open the file for reading.")
		#return
	#
	#var json = JSON.new()
	#var json_string = file.get_as_text()
	#file.close()
	#
	#var error = json.parse(json_string)
	#if error != OK:
		#print("Failed to parse JSON: ", json.get_error_message())
		#return
	#
	#var bindings_dict = json.get_data()
	#
	#for action in InputMap.get_actions():
		#InputMap.action_erase_events(action)
#
	#for action in bindings_dict.keys():
			#var event_codes = bindings_dict[action]
			#for event_code in event_codes:
				#print(action, ": ", event_code)
