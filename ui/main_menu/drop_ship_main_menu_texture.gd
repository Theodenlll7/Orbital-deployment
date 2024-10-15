extends TextureRect
@onready var animation_player_dropship: AnimationPlayer = $"../AnimationPlayer"
@onready var ship_audio_stream_player: AudioStreamPlayer = $"../ShipAudioStreamPlayer"
const SHIP_MOVMENT = preload("res://assets/Sound/UI/ship_movment.ogg")

# Variables to control the motion
var amplitude  = 50.0  
var speed = 2.0     
var start_position = Vector2()  
var time_elapsed = 0.0
var get_new_start_position = false

var animation_played: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_dropship.play("init_dropship")
	ship_audio_stream_player.stream = SHIP_MOVMENT
	ship_audio_stream_player.bus = "Ship"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if animation_player_dropship.current_animation != "":
		if !animation_played:
			ship_audio_stream_player.play()
			animation_played = true
		start_position = position
		time_elapsed = 0.0
	else:
		animation_played = false
	time_elapsed += delta
	position.y = start_position.y + amplitude * sin(time_elapsed * speed) 
