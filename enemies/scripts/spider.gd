extends CharacterBody2D

@export var target: Node2D = null

@onready var animated_sprite := $AnimatedSprite2D

var is_dead := false


func _ready():
	if !target:
		target = get_tree().get_first_node_in_group("players")


func _physics_process(_delta):
	if is_dead:
		return
	animate()


func _on_target_reached():
	velocity = Vector2.ZERO


func _on_health_component_died() -> void:
	is_dead = true
	animated_sprite.play("die")
	animated_sprite.animation_finished.connect(on_death_animation_finished)


func on_death_animation_finished() -> void:
	ExperiencePoints.add_experience(20)
	queue_free()


func animate() -> void:
	if abs(velocity) > Vector2(0.1, 0.1):
		animated_sprite.play("run_h")
		if velocity.x > 0.0:
			animated_sprite.flip_h = true
		elif velocity.x < 0.0:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
