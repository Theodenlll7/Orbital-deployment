extends Node2D
class_name Projectile_2D

@export var speed: float = 500.0
@export var lifetime: float = 2.0

var direction: Vector2


func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


func _process(delta: float) -> void:
	position += direction * speed * delta
