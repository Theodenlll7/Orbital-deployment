class_name Navigator2D extends NavigationAgent2D

var speed: float = 100
var actor: CharacterBody2D


func _ready() -> void:
	set_process(false)
	navigation_finished.connect(stop_navigation)
	actor = get_parent() as CharacterBody2D
	assert(actor, "Null or Invalid actor, actor need to be of type CharacterBody2D")


# Start navigation towards the target position
func start_navigation(navigation_target: Vector2, move_speed: float = 100):
	if !navigation_target:
		return false
	target_position = navigation_target
	speed = move_speed
	set_process(is_target_reachable())
	return is_target_reachable()


func stop_navigation():
	set_process(false)


# Update the movement every frame
func _process(_delta: float):
	move_towards_target()


func move_towards_target():
	var current_position = actor.global_position
	var next_path_position = get_next_path_position()
	actor.velocity = current_position.direction_to(next_path_position) * 150
	actor.move_and_slide()
