class_name hints
# Tooltips.gd - Dictionary of tooltips
static var data: Dictionary = {
}


static func get_random_hint() -> String:
	set_data()
	var keys = data.keys()
	var random_key = keys[int(randf_range(0, keys.size()))]
	return data[random_key]

static func set_data() -> void:
	var move_up_key = get_key("move_up")
	var move_left_key = get_key("move_left")
	var move_down_key = get_key("move_down")
	var move_right_key = get_key("move_right")
	var swap_wepon_key = get_key("swap_weapon") 

	data =  {
		1: "Use " + move_up_key + ", " + move_left_key + ", " + move_down_key + " and " + move_right_key + " to move around.",
		2: "If you have two wepons use " + swap_wepon_key + " to swap betwene.",
		4: "Keep an eye on your health bar!",
		5: "Use the xp from your fallen enemies to access skills, unlocking new traits for your player",
		6: "Surviving will only get harder and harder, plan your stratege well!",
		7: "Different enemies have different traits, plan your actions accordingly for best results",
		8: "Weapons can be bought in the dropods station, arm yourself to the teeth!"
	}
	
static func get_key(key: String) -> String:
	var action_events = InputMap.action_get_events(key)
	var action_event = action_events[0]
	var action_key_kode = OS.get_keycode_string(action_event.physical_keycode)
	return "%s" % action_key_kode
