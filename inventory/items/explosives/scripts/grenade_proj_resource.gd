extends ExplosiveResource
class_name ThrowableExplosiveResource

@export var explosive_scene: PackedScene = preload(
	"res://inventory/items/explosives/grenades/basic_grenade.tscn"
)

var audio_player: AudioStreamPlayer
var audio_stream: AudioStream

func _throw(explosive: Explosive):
	if not explosive_scene:
		return
	var explosive_instance = explosive_scene.instantiate()
	
	var position = explosive.to_global(muzzel_offset)
	var grenade = explosive_scene.instantiate()
	grenade.global_rotation = explosive.global_rotation
	grenade.global_position = position
	var mouse_position = explosive.get_viewport().get_camera_2d().get_global_mouse_position()

	var direction = (mouse_position - position).normalized()
	
	#Collision
	grenade.collision_layer = 1  
	grenade.collision_mask = 1  
	
	#Throwing
	grenade.direction = direction
	grenade.linear_velocity = direction * explosive.get_throw_speed();
	grenade.linear_damp = explosive.get_grenade_weight()
	
	#Spinn
	grenade.angular_velocity = deg_to_rad(randf_range(720, 1080))  # Random spin speed between 720 and 1080 degrees/second
	grenade.angular_damp = 1.0  # Damping to slow the spin over time
	
	#Explosion
	grenade.set_explosion_radius(explosive.get_explosion_radius())
	grenade.set_explosion_damage(explosive.get_explosion_damage())
	grenade.set_fuse_time(explosive.get_fuse_time())
	
	explosive.get_tree().current_scene.add_child(grenade)
	
