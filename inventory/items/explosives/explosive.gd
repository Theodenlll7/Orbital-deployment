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
	sprite.scale = Vector2(1.0, 1.0)  # Explosives might be larger in size
	sprite.texture = explosive_resource.texture
	add_child(sprite)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = explosive_resource.audio_stream_throw
	add_child(audio_player)

## Time to throw another explosive after the current one is thrown
@export var throw_rate: float = 1.0
var can_throw: bool = true
var cooldown: float = 0

func _process(delta) -> void:
	if !can_throw:
		cooldown -= delta
		if cooldown <= 0:
			can_throw = true

	if !is_thrown and throw_pressed():
		throw_explosive()

func throw_pressed() -> bool:
	return Input.is_action_just_pressed("throw_action")

func throw_explosive() -> void:
	if can_throw:
		is_thrown = true
		can_throw = false
		cooldown = throw_rate

		# Emit the signal that the explosive was thrown
		explosive_thrown.emit()

		# Play throwing sound
		audio_player.stream = explosive_resource.audio_stream_throw
		audio_player.play()

		# Start the fuse timer
		var timer = Timer.new()
		timer.wait_time = fuse_time
		timer.one_shot = true
		timer.timeout.connect(_on_fuse_time_end)
		add_child(timer)
		timer.start()

		# You could add a throw animation or movement here
		var tween = create_tween()
		tween.tween_property(sprite, "position", sprite.position + Vector2(200, -100), 0.5)  # Simple throw arc
		tween.play()

func _on_fuse_time_end() -> void:
	# Play explosion sound
	audio_player.stream = explosive_resource.audio_stream_explode
	audio_player.play()

	# Trigger the explosion
	explode()

func explode() -> void:
	# Emit the explosion signal
	explosive_exploded.emit()

	# Handle the explosion logic, e.g., deal damage, apply area effect
	area_damage()

	# Remove the explosive object (or hide it, if needed)
	queue_free()

func area_damage() -> void:
	# Implement logic to apply damage to nearby objects in range
	var explosion_area = Area2D.new()
	explosion_area.position = self.position
	explosion_area.set_radius(explosive_resource.explosion_radius)
	add_child(explosion_area)

	for body in explosion_area.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(explosive_resource.damage)

# Accessor methods for explosion properties
func get_explosion_damage() -> int:
	return explosive_resource.damage

func get_explosion_radius() -> float:
	return explosive_resource.explosion_radius

func get_fuse_time() -> float:
	return fuse_time
