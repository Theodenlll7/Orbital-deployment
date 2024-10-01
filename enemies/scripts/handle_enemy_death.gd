class_name HandleEnemeyDeath extends Node

func _ready() -> void:
	var hp = get_parent().get_node("HealthComponent") as HealthComponent
	hp.died.connect(_on_death)

func _on_death() -> void:
	ExperiencePoints.add_experience(10)
	get_parent().queue_free()
