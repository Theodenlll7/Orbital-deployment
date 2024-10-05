extends CharacterBody2D

@export var target: Node2D = null

@export var speed := 95
var player_position := Vector2.ZERO

@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite := $AnimatedSprite2D

var map_ready := false
var is_dead := false


func _ready():
	if !target:
		target = get_tree().get_first_node_in_group("players")
	# Make sure to not await during _ready.
	set_physics_process(false)
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame
	if target:
		agent.target_position = target.global_position
	set_physics_process(true)


func _physics_process(_delta):
	if is_dead:
		return
	#if target:
	#agent.target_position = target.global_position
	#var current_agent_position = global_position
	#var next_path_position = agent.get_next_path_position()
	#velocity = current_agent_position.direction_to(next_path_position) * speed

	#move_and_slide()
	animate()


func _on_target_reached():
	velocity = Vector2.ZERO


func set_target_position(target_position: Vector2):
	agent.target_position = target.global_position


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
