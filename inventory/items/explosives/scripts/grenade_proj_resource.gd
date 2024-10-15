extends ExplosiveResource
class_name ThrowableExplosiveResource

@export var explosive_grenade: PackedScene = preload(
	"res://inventory/items/explosives/grenades/basic_grenade.tscn"
)

var audio_player: AudioStreamPlayer
var audio_stream: AudioStream

func _throw(explosive: HeldExplosive):
	if not explosive_grenade:
		return

	var grenade = explosive_grenade.instantiate()
	grenade.global_rotation = explosive.global_rotation
	grenade.global_position = explosive.global_position
	var mouse_position = explosive.get_viewport().get_camera_2d().get_global_mouse_position()
	var direction = (mouse_position - grenade.global_position).normalized()
	
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
