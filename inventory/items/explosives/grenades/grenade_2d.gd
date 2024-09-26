extends RigidBody2D
class_name Grenade_2D

var throw_speed: float = 600.0
var explosion_damage: int = 100
var explosion_radius: float = 200.0
var fuse_time: float = 2.0

var direction: Vector2 = Vector2(1,1)
var explosion_area: Area2D

@onready var animated_sprite_explosion = $AnimatedSprite2D


func _ready() -> void:
	explosion_area = Area2D.new()
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = explosion_radius
	collision_shape.shape = circle_shape
	explosion_area.add_child(collision_shape)
	explosion_area.monitorable = true
	explosion_area.monitoring = false
	explosion_area.collision_layer = 3  # Adjust as needed
	explosion_area.collision_mask = 2  # Adjust as needed
	add_child(explosion_area)
	
	explosion_area.connect("body_entered", _on_body_entered)
	
	var timer = Timer.new()
	timer.wait_time = fuse_time
	timer.one_shot = true
	timer.timeout.connect(_on_fuse_time_end)
	add_child(timer)
	timer.start()

func _on_fuse_time_end() -> void:
	_explode()

func _explode() -> void:
	explosion_area.monitoring = true


# Signal handler for body entered
func _on_body_entered(body) -> void:
	var hp = body.get_node_or_null("HealthComponent") as HealthComponent
	if hp:
		hp.damage(explosion_damage)
	
	queue_free()

func set_fuse_time(time: float):
	fuse_time = time

# Setter for explosion damage
func set_explosion_damage(damage: int):
	explosion_damage = damage

# Setter for explosion radius
func set_explosion_radius(radius: float):
	explosion_radius = radius
