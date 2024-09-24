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
		print("THROWING")
		is_thrown = true
		can_throw = false
		cooldown = throw_rate

		explosive_thrown.emit()

		audio_player.stream = explosive_resource.audio_stream_throw
		audio_player.play()
		throw_grenade()
		
func throw_grenade() -> void:
	explosive_resource.throw_action.call(self)
	
func area_damage() -> void:
	# Implement logic to apply damage to nearby objects in range
	var explosion_area = Area2D.new()
	explosion_area.position = self.position

	# Create a CollisionShape2D to define the area
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()  # Create a circle shape
	circle_shape.radius = explosive_resource.explosion_radius  # Set the radius from the resource

	collision_shape.shape = circle_shape  # Assign the shape to the collision shape
	explosion_area.add_child(collision_shape)  # Add the collision shape to the explosion area

	# Add the Area2D to the scene tree
	add_child(explosion_area)

	# Detect overlapping bodies
	var overlapping_bodies = explosion_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("take_damage"):
			body.take_damage(explosive_resource.damage)

	# Optionally, you can queue_free the explosion_area after use
	explosion_area.queue_free()
# Accessor methods for explosion properties
func get_explosion_damage() -> int:
	return explosive_resource.explosion_damage

func get_throw_speed() -> float:
	return explosive_resource.throw_speed

func get_explosion_radius() -> float:
	return explosive_resource.explosion_radius

func get_fuse_time() -> float:
	return fuse_time
