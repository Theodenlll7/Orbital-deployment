extends Node2D
class_name HeldExplosive

var explosive_resource: ExplosiveResource

var audio_player: AudioStreamPlayer
var sprite: Sprite2D
var fuse_time: float = 3.0  # Default fuse time for explosion

var can_throw := true

var cooldown_timer : Timer

func _init(data: ExplosiveResource):
	explosive_resource = data

func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = explosive_resource.audio_stream_throw
	add_child(audio_player)
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = explosive_resource.throw_cooldown
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(func(): can_throw = true)

func _process(delta: float) -> void:
	if can_throw and Input.is_action_just_pressed("throw_action"):
		throw_explosive()

func throw_explosive() -> void:
	if explosive_resource.explosive_count > 0:
		can_throw = false
		cooldown_timer.start()
		audio_player.stream = explosive_resource.audio_stream_throw
		audio_player.play()
		explosive_resource.throw(self)

	
func get_explosion_damage() -> int:
	return explosive_resource.explosion_damage

func get_throw_speed() -> float:
	return explosive_resource.throw_speed

func get_explosion_radius() -> float:
	return explosive_resource.explosion_radius

func get_fuse_time() -> float:
	return explosive_resource.fuse_time
	
func get_grenade_weight() -> float:
	return explosive_resource.grenade_weight
