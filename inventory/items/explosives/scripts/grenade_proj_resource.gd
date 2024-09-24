extends ExplosiveResource
class_name ThrowableExplosiveResource

@export var explosive_scene: PackedScene = preload(
	"res://inventory/items/explosives/grenades/basic_grenade.tscn"
)

func _explode(explosive: Explosive):
	## If no explosive scene is assigned, return early
	if not explosive_scene:
		return

	## Instantiate the explosive scene (e.g., grenade)
	var explosive_instance = explosive_scene.instantiate()

	## Set the initial position and rotation of the explosive when thrown
	var position = explosive.to_global(throw_offset)
	explosive_instance.global_position = position
	explosive_instance.global_rotation = explosive.global_rotation

	## Set the explosive's fuse timer (how long before it explodes)
	explosive_instance.fuse_time = get_fuse_time()

	## Set explosion parameters (damage, radius, etc.)
	explosive_instance.explosion_damage = get_explosion_damage()
	explosive_instance.explosion_radius = get_explosion_radius()

	## Add the explosive to the current scene
	explosive.get_tree().current_scene.add_child(explosive_instance)


func get_fuse_time() -> float:
	return fuse_time

func get_explosion_damage() -> int:
	return explosion_damage

func get_explosion_radius() -> float:
	return explosion_radius
