extends Node2D
class_name Explosive

signal explosive_thrown()
signal explosive_exploded()

var explosive_resource: ExplosiveResource

var audio_player: AudioStreamPlayer
var sprite: Sprite2D
var is_thrown: bool = false
var fuse_time: float = 3.0  # Default fuse time for explosion

func _init(data: ExplosiveResource):
	explosive_resource = data

func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.scale = Vector2(0.8, 0.8)  # Explosives might be larger in size
	sprite.texture = explosive_resource.texture
	add_child(sprite)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = explosive_resource.audio_stream_throw
	add_child(audio_player)


@export var throw_rate: float = 1.0
var can_throw: bool = true
var cooldown: float = 0

func _process(delta) -> void:
	if !can_throw:
		cooldown -= delta
		if cooldown <= 0:
			print("can throw again")
			can_throw = true

	if can_throw and throw_pressed():
		throw_explosive()

func throw_pressed() -> bool:
	return Input.is_action_just_pressed("throw_action")

func throw_explosive() -> void:
	if explosive_resource.has_explosive_quantity and explosive_resource.explosive_count > 0:
		is_thrown = true
		can_throw = false
		cooldown = throw_rate

		explosive_thrown.emit()
		explosive_resource.explosive_count -= 1
		
		audio_player.stream = explosive_resource.audio_stream_throw
		audio_player.play()
		throw_grenade()
		
		var timer = Timer.new()
		timer.wait_time = fuse_time
		timer.one_shot = true
		timer.timeout.connect(_on_fuse_time_end)
		add_child(timer)
		timer.start()

func _on_fuse_time_end() -> void:
	audio_player.stream = explosive_resource.audio_stream_explode
	audio_player.play()

	
func throw_grenade() -> void:
	explosive_resource.throw_action.call(self)
	
func get_explosion_damage() -> int:
	return explosive_resource.explosion_damage

func get_throw_speed() -> float:
	return explosive_resource.throw_speed

func get_explosion_radius() -> float:
	return explosive_resource.explosion_radius

func get_fuse_time() -> float:
	return fuse_time
	
func get_grenade_weight() -> float:
	return explosive_resource.grenade_weight

func get_grenade():
	return explosive_resource.grenade_scene
