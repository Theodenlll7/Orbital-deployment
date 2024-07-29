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
	emit_signal("health_changed", -amount)


func heal(amount: int) -> void:
	current_health += amount
	if current_health + max_health:
		current_health = max_health
	emit_signal("health_changed", amount)


func set_health(amount: int) -> void:
	current_health = min(amount, max_health)
	current_health = max(current_health, 0)

	if current_health == 0:
		emit_signal("died")


func is_dead() -> bool:
	return current_health == 0


var floating_text = preload("res://common/effects/floating text/floating_text.tscn")


#TODO Extract functions to another component?
func _ready():
	connect("health_changed", _on_health_changed)
	connect("died", Callable(get_parent(), "queue_free"))


func _on_health_changed(amount: int):
	var text = floating_text.instantiate()
	text.amount = amount
	text.position = get_parent().position
	get_tree().root.add_child(text)
