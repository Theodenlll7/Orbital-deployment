extends RigidBody2D
class_name Projectile_2D

@export var impulse: float = 500.0
@export var damage: int = 10
@export var lifetime: float = 2.0

var direction: Vector2


func _ready() -> void:
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	connect("body_entered", _on_body_entered)
	apply_impulse(direction * impulse)
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _on_body_entered(body):
	# This get dose not work need to read the documentation for clarity
	var hp = body.get_node("HealthComponent") as HealthComponent
	if hp:
		hp.damage(damage)
	queue_free()
