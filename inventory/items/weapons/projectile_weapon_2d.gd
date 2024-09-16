extends Weapon
class_name ProjectileWeapon2D

func _init(data : ProjectileWeaponData):
	weapon_data = data
	
var muzzel : Marker2D

func _ready() -> void:
	assert(weapon_data is ProjectileWeaponData, "weapon_data is the wrong type for Projectile Weapon")
	muzzel = Marker2D.new()
	muzzel.position = weapon_data.muzzle_offset
	add_child(muzzel)

func attack() -> void:
	if not weapon_data.projectile_scene:
		return

	var position = muzzel.global_position
	var projectile = weapon_data.projectile_scene.instantiate()
	projectile.global_position = position

	var mouse_position = get_viewport().get_camera_2d().get_global_mouse_position()

	var direction = (mouse_position - position).normalized()

	projectile.direction = direction

	get_tree().current_scene.add_child(projectile)
