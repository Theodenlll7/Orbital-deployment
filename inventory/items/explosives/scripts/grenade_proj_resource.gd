extends ExplosiveResource
class_name ThrowableExplosiveResource

@export var explosive_scene: PackedScene = preload(
	"res://inventory/items/explosives/grenades/basic_grenade.tscn"
)

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

	grenade.direction = direction
	grenade.linear_velocity = direction * explosive.get_throw_speed();

	explosive.get_tree().current_scene.add_child(grenade)


func get_fuse_time() -> float:
	return fuse_time

func get_explosion_damage() -> int:
	return explosion_damage

func get_explosion_radius() -> float:
	return explosion_radius
