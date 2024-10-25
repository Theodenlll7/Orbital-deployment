@tool
extends Control

enum AudioBus { Master }
@export var audio_bus: AudioBus = AudioBus.Master

@onready var stream_label = $StreamLabel as Label
@onready var slider = $HSlider as HSlider
@onready var value_label = $ValueLabel as Label

const config_file_path = "user://audio_settings.cfg"


func _ready() -> void:
	stream_label.text = AudioServer.get_bus_name(audio_bus)
	slider.value_changed.connect(_on_value_changed)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus)) * slider.max_value


func _on_value_changed(value: float) -> void:
	var new_volume = min(value / slider.max_value, 1)
	Settings.set_audio_bus_volume(audio_bus, new_volume)
	_update_value_label()


func _update_value_label() -> void:
	value_label.text = str(slider.value) + " %"


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
