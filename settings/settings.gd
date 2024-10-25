extends Node
const config_file_path = "user://settings.cfg"

static var config: ConfigFile

enum AudioBus { Master }

var save_timer: Timer


func _ready() -> void:
	load_settings()
	init_save_scheduler()


func load_settings() -> void:
	config = ConfigFile.new()
	var err = config.load(config_file_path)

	if err != OK:
		print("No previous settings config found.")
		return

	_load_audio_volumes()


##################################################################
##                          Keybindings                         ##
##################################################################


func bind_action_event(action_name: StringName, event: InputEvent) -> void:
	InputMap.action_add_event(action_name, event)
	_save_action_event()


func erase_action_event(action_name: StringName, event: InputEvent) -> void:
	InputMap.action_erase_event(action_name, event)
	_remove_action_event()


func _save_action_event() -> void:
	save()


func _remove_action_event() -> void:
	save()


##################################################################
##                           Audio                              ##
##################################################################


func set_audio_bus_volume(bus: int, volume: float) -> void:
	AudioServer.set_bus_volume_db(bus, linear_to_db(min(volume, 1)))
	config.set_value("AudioVolumes", AudioServer.get_bus_name(bus), volume)
	save()


func _load_audio_volumes() -> void:
	for bus in AudioServer.bus_count:
		var saved_volume = config.get_value("AudioVolumes", AudioServer.get_bus_name(bus), null)
		if saved_volume != null:
			AudioServer.set_bus_volume_db(bus, linear_to_db(min(saved_volume, 1)))


##################################################################
##                         Save Config                          ##
##################################################################


func init_save_scheduler() -> void:
	# Initialize the save timer
	save_timer = Timer.new()
	save_timer.set_wait_time(1.0)  # Set to 1 second
	save_timer.set_one_shot(true)
	save_timer.timeout.connect(_on_save_timer_timeout)
	add_child(save_timer)


func save() -> void:
	save_timer.start()


func _on_save_timer_timeout() -> void:
	config.save(config_file_path)
