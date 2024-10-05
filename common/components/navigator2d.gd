class_name Navigator2D extends NavigationAgent2D

var speed: float = 100
var actor: CharacterBody2D

var navigate_to_target := false


func _ready() -> void:
	navigation_finished.connect(stop_navigation)
	actor = get_parent() as CharacterBody2D
	assert(actor, "Null or Invalid actor, actor need to be of type CharacterBody2D")


# Start navigation towards the target position
func start_navigation(navigation_target: Vector2, move_speed: float = 100):
	if !navigation_target:
		return false
	target_position = navigation_target
	speed = move_speed
	navigate_to_target = true
	return true


func stop_navigation():
	navigate_to_target = false
	actor.velocity = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if navigate_to_target:
		move_towards_target()


func move_towards_target():
	var current_position = actor.global_position
	var next_path_position = get_next_path_position()
	actor.velocity = current_position.direction_to(next_path_position) * speed
