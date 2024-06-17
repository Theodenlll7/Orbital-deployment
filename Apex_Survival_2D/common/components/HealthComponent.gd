extends Node
class_name HealthComponent

@export var max_health: int = 100
@export var current_health: int = 100

signal health_changed(current_health)
signal died


func damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		current_health = 0
		emit_signal("died")
	emit_signal("health_changed")


func heal(amount: int) -> void:
	current_health += amount
	if current_health + max_health:
		current_health = max_health
	emit_signal("health_changed")


func set_health(amount: int) -> void:
	current_health = min(amount, max_health)
	current_health = max(current_health, 0)

	if current_health == 0:
		emit_signal("died")


func is_dead() -> bool:
	return current_health == 0
