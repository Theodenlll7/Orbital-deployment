extends CharacterBody2D

@export var move_speed = 100
@export var dodge_speed = 200
@export var dodge_duration = 0.4
@export var dodge_cooldown = 0.5

@onready var animated_sprite := $AnimatedSprite2D

var dodge_timer = -dodge_cooldown
var can_dodge = true


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_dodge and Input.is_action_just_pressed("dodge"):
		start_dodge()

	if dodge_timer > -dodge_cooldown:
		dodge_timer -= delta
		if dodge_timer <= -dodge_cooldown:
			can_dodge = true

	move_player()


func move_player() -> void:
	if dodge_timer > 0:
		velocity = velocity.normalized() * dodge_speed
		animated_sprite.play("roll_h")
	else:
		var input_vector = (
			Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		)
		velocity = input_vector * move_speed
		
		if input_vector.x < 0:
			animated_sprite.flip_h = true;
		elif input_vector.x > 0:
			animated_sprite.flip_h = false;

		if !velocity.is_zero_approx():
			animated_sprite.play("run_h")
		else:
			animated_sprite.play("idle")

	

	move_and_slide()


func start_dodge() -> void:
	can_dodge = false
	dodge_timer = dodge_duration
