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
	explosion_area.monitorable = false
	explosion_area.monitoring = false
	explosion_area.collision_mask = 129
	add_child(explosion_area)
	
	scale_explosion_sprite()
	
	explosion_area.area_entered.connect(_on_area_entered)
	
	var timer = Timer.new()
	timer.wait_time = fuse_time
	timer.one_shot = true
	timer.timeout.connect(_on_fuse_time_end)
	add_child(timer)
	timer.start()

func _on_fuse_time_end() -> void:
	_explode()
	
func scale_explosion_sprite():
	var explosion_scale_factor = explosion_radius / 38
	animated_sprite_explosion.scale = Vector2(explosion_scale_factor, explosion_scale_factor)
	
func _explode() -> void:
	var sprite_frames = animated_sprite_explosion.get_sprite_frames()
	sprite_frames.set_animation_loop("explode", false)
	animated_sprite_explosion.visible = true
	animated_sprite_explosion.play("explode")

	explosion_area.monitoring = true
	

func _on_area_entered(hurtbox : Hurtbox) -> void:
	if hurtbox:
		hurtbox.damage(explosion_damage)
	
	

func set_fuse_time(time: float):
	fuse_time = time

# Setter for explosion damage
func set_explosion_damage(damage: int):
	explosion_damage = damage

# Setter for explosion radius
func set_explosion_radius(radius: float):
	explosion_radius = radius


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
