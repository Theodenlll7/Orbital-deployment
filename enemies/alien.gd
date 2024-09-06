extends CharacterBody2D

@export var target: Node2D = null

@export var speed := 100
var player_position := Vector2.ZERO

@onready var agent: NavigationAgent2D = $NavigationAgent2D

var map_ready := false


func _ready():
	# Make sure to not await during _ready.
	set_physics_process(false)
	call_deferred("actor_setup")


func actor_setup():
	await get_tree().physics_frame
	if target:
		agent.target_position = target.global_position
	set_physics_process(true)


func _physics_process(_delta):
	if target:
		agent.target_position = target.global_position

	var current_agent_position = global_position
	var next_path_position = agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed

	print(agent.get_current_navigation_path())

	move_and_slide()


func _on_target_reached():
	velocity = Vector2.ZERO


func set_target_position(target_position: Vector2):
	agent.target_position = target.global_position
