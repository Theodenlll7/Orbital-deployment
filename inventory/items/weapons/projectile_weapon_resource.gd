extends WeaponResource
class_name ProjectileWeaponResource

@export var projectile_scene: PackedScene = preload(
	"res://inventory/items/weapons/projectiles/basic_projectile.tscn"
)
@export var muzzle_offset: Vector2 = Vector2(0, 0)


func _attack(weapon: Weapon):
	if not projectile_scene:
		return

	var position = weapon.to_global(muzzel_offset)
	var projectile = projectile_scene.instantiate()
	projectile.global_position = position

	var mouse_position = weapon.get_viewport().get_camera_2d().get_global_mouse_position()

	var direction = (mouse_position - position).normalized()

	projectile.direction = direction

	weapon.get_tree().current_scene.add_child(projectile)
