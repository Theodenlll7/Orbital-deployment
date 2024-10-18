extends RigidBody2D
class_name Grenade_2D

var throw_speed: float = 600.0
var explosion_damage: int = 100
var explosion_radius: float = 160.0
var fuse_time: float = 2.0

var direction: Vector2 = Vector2(1,1)
var explosion_area: Area2D

var explosive_resource : ExplosiveResource

@onready var animated_sprite_explosion = $AnimatedSprite2D
@onready var pointlight = $PointLight2D


func _ready() -> void:
	animated_sprite_explosion.visible = false
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
		
	explosion_area.area_entered.connect(_on_area_entered)
	
	var timer = Timer.new()
	timer.wait_time = explosive_resource.fuse_time
	timer.one_shot = true
	timer.timeout.connect(_on_fuse_time_end)
	add_child(timer)
	timer.start()

func _on_fuse_time_end() -> void:
	_explode()
	
	
func _explode() -> void:
	var player = AudioStreamPlayer.new()
	player.stream = explosive_resource.audio_stream_explode
	player.bus = "Explosive"
	get_tree().current_scene.add_child(player)
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
	
	animated_sprite_explosion.visible= true
	var sprite_frames = animated_sprite_explosion.get_sprite_frames()
	sprite_frames.set_animation_loop("explode", false)
	
	animated_sprite_explosion.scale = explosive_resource.explosion_radius * 2.0 / 80.0 * Vector2(0.5, 0.5)
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
