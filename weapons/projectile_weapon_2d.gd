extends Weapon
class_name Projectile_Weapon_2D

@export var projectile_scene: PackedScene = null
@export var muzzle: Marker2D = null


func weapon_attack() -> void:
	if not projectile_scene:
		return

	var position = muzzle.global_position
	var projectile = projectile_scene.instantiate()
	projectile.global_position = position

	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()

	var direction = (mouse_position - position).normalized()

	projectile.direction = direction

	get_tree().current_scene.add_child(projectile)
