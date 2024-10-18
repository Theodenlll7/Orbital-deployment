extends WeaponResource
class_name ProjectileWeaponResource

@export var projectile_scene: PackedScene = preload(
	"res://inventory/items/weapons/projectiles/basic_projectile.tscn"
)


func attack(weapon: Weapon):
	if not projectile_scene:
		return

	for i in range(weapon.get_bullets_per_shot()):
		var position = weapon.to_global(muzzle_offset)
		var projectile = projectile_scene.instantiate()
		projectile.global_rotation = weapon.global_rotation
		projectile.global_position = position

		var direction = Vector2.RIGHT.rotated(weapon.global_rotation)
		var spread = deg_to_rad(weapon.get_bullet_spread())
		var random_angle = randf_range(-spread, spread)
		direction = direction.rotated(random_angle)

		projectile.direction = direction
		projectile.linear_velocity = direction * weapon.get_bullet_speed()
		projectile.damage = weapon.get_bullet_damage()

		projectile.lifetime = weapon.get_bullet_lifetime()

		weapon.get_tree().current_scene.add_child(projectile)
