extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var loading_text: Label = $Control/Label/MarginContainer/HBoxContainer/loadingText
@onready var loading_percent: Label = $Control/Label/MarginContainer/HBoxContainer/loadingPercent

var next_scene = "res://scenes/level1.tscn"

var time: float = 0.0;
var sinTime: float = 0.0
var speed: float = 2.0
var minOpacity = 0.2

var min_loading_time: float = 1.5
var load_started_time: float = 0.0
var loading_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("loading_animation")
	ResourceLoader.load_threaded_request(next_scene)
	load_started_time = time

func flashLoadingText() -> void:
	sinTime = minOpacity + (1 - minOpacity) * ((sin(time * speed) + 1) * 0.5)
	loading_text.modulate.a = sinTime

func _process(delta: float) -> void:
	var progress = []
	time += delta
	flashLoadingText()

	ResourceLoader.load_threaded_get_status(next_scene, progress)
	loading_percent.text = str(progress[0]*100)+"%"
	
	if progress[0] == 1 and not loading_complete:
		loading_complete = true

	if loading_complete and time >= min_loading_time  + load_started_time:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		get_tree().change_scene_to_packed(packed_scene)
