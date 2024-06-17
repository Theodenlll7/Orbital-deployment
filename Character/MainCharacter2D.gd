extends CharacterBody2D

var player_stats: PlayerStats

var input = Vector2.ZERO

var friction 
var max_speed 
var acceleration 

func _ready():
	player_stats = PlayerStats.new()
	friction = player_stats.friction
	max_speed = player_stats.max_speed
	acceleration = player_stats.acceleration

func _physics_process(delta):
	player_movement(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"))
	input.y = int(Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	if input == Vector2.ZERO:
		if velocity.length() > (friction* delta):
			velocity -= velocity.normalized()*(friction*delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity+= (input*acceleration*delta)
		velocity = velocity.limit_length(max_speed)
	
	move_and_slide()
		
