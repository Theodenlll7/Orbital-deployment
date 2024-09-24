extends RigidBody2D
class_name Grenade_2D

@export var throw_speed: float = 600.0
@export var explosion_damage: int = 100
@export var explosion_radius: float = 200.0
@export var fuse_time: float = 2.0

var direction: Vector2 = Vector2(1,1)
var explosion_area: Area2D

var audio_player: AudioStreamPlayer
@export var audio_stream: AudioStream

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	
	explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.set_radius(explosion_radius)
	explosion_area.add_child(collision_shape)
	explosion_area.monitorable = true
	explosion_area.monitoring = false  # Turn it on only at explosion time
	add_child(explosion_area)
	
	var timer = Timer.new()
	timer.wait_time = fuse_time
	timer.one_shot = true
	timer.timeout.connect(_on_fuse_time_end)
	add_child(timer)
	timer.start()
	
	
func _on_fuse_time_end() -> void:
	audio_player.stream = audio_stream
	audio_player.play()
	await audio_player.finished 
	_explode()

	
func _explode() -> void:
	explosion_area.monitoring = true
	
	var overlapping_bodies = explosion_area.get_overlapping_bodies()

	for body in overlapping_bodies:
		if body.has_method("take_damage"):
			body.take_damage(explosion_damage)

	
	queue_free() 
