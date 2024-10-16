extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var loading_text: Label = $Control/Label/MarginContainer/HBoxContainer/loadingText
@onready var loading_percent: Label = $Control/Label/MarginContainer/HBoxContainer/loadingPercent

@onready var ambient_audio_stream_player: AudioStreamPlayer = $AmbientAudioStreamPlayer
@onready var music_audio_stream_player: AudioStreamPlayer = $MusicAudioStreamPlayer
@onready var rich_text_label: RichTextLabel = $Control/Tip/MarginContainer/Control/Panel/MarginContainer/VBoxContainer/RichTextLabel

const LOADING_MUSIC = preload("res://assets/Sound/UI/loading_music.ogg")
const LOADING_AMBIENT = preload("res://assets/Sound/UI/loading_ambient.ogg")
var next_scene = ""

var time: float = 0.0;
var sinTime: float = 0.0
var speed: float = 2.0
var minOpacity = 0.2

var min_loading_time: float = 6.0
var load_started_time: float = 0.0
var loading_complete: bool = false

var mission_ID: String = ""



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("loading_animation")
	next_scene = MissionManager.get_mission_path_by_id(mission_ID)
	
	set_random_hint()
	
	ResourceLoader.load_threaded_request(next_scene)
	load_started_time = time
	print("In load level the ID is: ", mission_ID)
	initAudio()

func initAudio() -> void:
	ambient_audio_stream_player.stream = LOADING_AMBIENT
	ambient_audio_stream_player.bus = "Loading"
	ambient_audio_stream_player.stream.loop = true
	#ambient_audio_stream_player.play()
	
	music_audio_stream_player.stream = LOADING_MUSIC
	music_audio_stream_player.bus = "Music"
	music_audio_stream_player.stream.loop = true
	music_audio_stream_player.play()

func flashLoadingText() -> void:
	sinTime = minOpacity + (1 - minOpacity) * ((sin(time * speed) + 1) * 0.5)
	loading_text.modulate.a = sinTime
	
func set_random_hint() -> void:
	rich_text_label.clear()
	rich_text_label.append_text(loading_hints.get_random_hint())

func _process(delta: float) -> void:
	var progress = []
	time += delta
	flashLoadingText()

	ResourceLoader.load_threaded_get_status(next_scene, progress)

	if progress.size() > 0:
		loading_percent.text = str(floor(progress[0]) * 100) + "%"
	
	if progress[0] == 1 and not loading_complete:
		loading_complete = true
		print("Loading complete!")

	if loading_complete and time >= min_loading_time + load_started_time:
		var packed_scene = ResourceLoader.load_threaded_get(next_scene)
		if packed_scene:
			print("Successfully loaded packed scene")
			get_tree().unload_current_scene()  
			get_tree().change_scene_to_packed(packed_scene)
			queue_free()
		else:
			print("Error: Unable to load packed scene. It is null.")
