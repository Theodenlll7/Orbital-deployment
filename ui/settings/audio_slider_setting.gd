@tool
extends Control

enum AudioBus { Master }
@export var audio_bus: AudioBus = AudioBus.Master

@onready var stream_label = $StreamLabel as Label
@onready var slider = $HSlider as HSlider
@onready var value_label = $ValueLabel as Label

const config_file_path = "user://audio_settings.cfg"


func _ready() -> void:
	_load_audio_setting(audio_bus)
	stream_label.text = AudioServer.get_bus_name(audio_bus)
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus)) * slider.max_value


func _on_value_changed(value: float) -> void:
	var new_volume = min(value / slider.max_value, 1)
	AudioServer.set_bus_volume_db(audio_bus, linear_to_db(new_volume))
	_save_audio_setting(audio_bus, new_volume)
	_update_value_label()


func _update_value_label() -> void:
	value_label.text = str(slider.value) + " %"


static func _load_audio_setting(bus: AudioBus) -> void:
	var config = ConfigFile.new()
	var err = config.load(config_file_path)

	if err == OK:
		var saved_volume = config.get_value("AudioBuses", AudioServer.get_bus_name(bus), null)
		if saved_volume != null:
			# Apply the saved volume level to the audio bus
			AudioServer.set_bus_volume_db(bus, linear_to_db(min(saved_volume, 1)))
	else:
		print("No previous audio settings found.")


static func _save_audio_setting(bus: AudioBus, volume: float) -> void:
	var config = ConfigFile.new()
	config.load(config_file_path)  # Load existing settings if any

	# Save the slider value (linear volume) under the bus name
	config.set_value("AudioBuses", AudioServer.get_bus_name(bus), volume)
	config.save(config_file_path)


func _validate_property(property: Dictionary):
	if property.name == "audio_bus":
		var busNumber = AudioServer.bus_count
		var options = ""
		for i in busNumber:
			if i > 0:
				options += ","
			var busName = AudioServer.get_bus_name(i)
			options += busName
		property.hint_string = options
