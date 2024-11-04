extends TextureRect

@onready var ship_audio_stream_player: AudioStreamPlayer = $ShipAudioStreamPlayer
@onready var hover_audio_stream_player: AudioStreamPlayer = $HoverAudioStreamPlayer

const SHIP_MOVMENT = preload("res://assets/Sound/UI/ship_movment.ogg")
const SHIP_HOVER = preload("res://assets/Sound/UI/ship_hover.ogg")

# Variables to control the motion
var amplitude = 50.0
var speed = 2.0
var start_position = Vector2()
var time_elapsed = 0.0

var animation_played: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_audio()
	set_process(false)
	start_position = position
	start_entrance_animation()

# Sets up audio streams and starts the hover sound loop
func setup_audio() -> void:
	ship_audio_stream_player.stream = SHIP_MOVMENT
	ship_audio_stream_player.bus = "Ship"
	hover_audio_stream_player.stream = SHIP_HOVER
	hover_audio_stream_player.bus = "Ship_hover"
	hover_audio_stream_player.stream.loop = true
	hover_audio_stream_player.play()

# Function to animate the entrance of the dropship with a curve motion
func start_entrance_animation() -> void:
	time_elapsed = 0
	# Get viewport size to calculate an off-screen starting position
	var viewport_size = get_viewport_rect().size
	var offscreen_start_position = Vector2(viewport_size.x * -1, viewport_size.y * -0.8)
	
	fly(offscreen_start_position, start_position)

func start_mission_animation() -> void:
	time_elapsed = 0
	# Get viewport size to calculate an off-screen starting position
	var viewport_size = get_viewport_rect().size
	var offscreen_start_position = Vector2(viewport_size.x * -0.9, viewport_size.y * 1.2)
	fly(offscreen_start_position, Vector2.ZERO)

func fly(start_pos: Vector2, end_pos : Vector2) -> void:
	# Create a tween and apply entrance animation with easing
	var tween = create_tween()
	# Animate the ship from offscreen_start_position to the start position with easing
	(
	tween.tween_property(self, "position", end_pos, 1.2)
	.from(start_pos).set_trans(Tween.TRANS_SINE)
	.set_ease(Tween.EASE_OUT)
	)
	tween.play()
	ship_audio_stream_player.play()
	tween.finished.connect(func(): set_process(true))


# Applies the hover motion effect to the dropship after the entrance animation is complete
func apply_hover_motion(delta: float) -> void:
	time_elapsed += delta
	position.y = start_position.y + amplitude * -sin(time_elapsed * speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	apply_hover_motion(delta)
