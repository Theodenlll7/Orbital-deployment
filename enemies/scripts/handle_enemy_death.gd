class_name HandleEnemeyDeath extends Node

signal died


func _ready() -> void:
	var hp = get_parent().get_node("HealthComponent") as HealthComponent
	hp.died.connect(_on_death)


func _on_death() -> void:
	ExperiencePoints.add_experience(10)
	died.emit()
	var lp = get_parent().get_node_or_null("LootSpawner") as LootSpawner
	if lp:
		lp.spawn_loot()
	get_parent().queue_free()
