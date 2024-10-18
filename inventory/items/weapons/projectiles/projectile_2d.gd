extends RigidBody2D
class_name Projectile2D

@export var speed: float = 2000.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2

@export var hit_collision_mask: int = 128

@onready var last_position: Vector2 = global_position


func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	body_entered.connect(_on_body_entered)

	var hitbox = $Hitbox as Hitbox
	if hitbox:
		hitbox.damage = damage
		hitbox.area_entered.connect(_on_area_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_area_entered(hurtbox: Hurtbox) -> void:
	if !hurtbox.is_invulnerable:
		queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()
