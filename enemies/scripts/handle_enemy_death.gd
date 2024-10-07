class_name HandleEnemeyDeath extends Node

signal died

@onready var animated_sprite := $"../CharacterAnimatedSprite2D"


func _ready() -> void:
	var hp = get_parent().get_node("HealthComponent") as HealthComponent
	hp.died.connect(_on_death)


func _on_death() -> void:
	died.emit()
	var lp = get_parent().get_node_or_null("LootSpawner") as LootSpawner
	if lp:
		lp.spawn_loot()

	var collider = get_parent().get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collider:
		collider.set_deferred("disabled", true)

	var mt = $"../MindTreeRoot"
	if mt:
		mt.disabled = true

	var move_slide = $"../ParentMoveAndSlide"
	if move_slide:
		move_slide.disabled = true

	if animated_sprite:
		animated_sprite.play("die")
		animated_sprite.animation_finished.connect(_on_death_animation_finished)
	else:
		_on_death_animation_finished()


func _on_death_animation_finished() -> void:
	ExperiencePoints.add_experience(20)
	get_parent().queue_free()
