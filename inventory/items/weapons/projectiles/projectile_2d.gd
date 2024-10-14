extends RigidBody2D
class_name Projectile2D

@export var speed: float = 2000.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2


func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	body_entered.connect(_on_body_entered)

	if $Hitbox:
		$Hitbox.damage = damage

	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()
