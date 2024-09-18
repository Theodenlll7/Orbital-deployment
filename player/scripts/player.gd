extends CharacterBody2D

class_name Player

@export var move_speed = 100
@export var dodge_speed = 200
@export var dodge_duration = 0.4
@export var dodge_cooldown = 0.5

@onready var animated_sprite := $AnimatedSprite2D
@onready var camera := $Camera2D
@onready var inventory := $Inventory

@onready var death_screen: DeathScreen = $PlayerHUD/death_screen

var dodge_timer = -dodge_cooldown
var can_dodge = true

var can_move := true

func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_player(delta)	

func _unhandled_input(event):
	if event.is_action_pressed("swap_weapon"):
		inventory.select_next_slot()
	

func move_player(delta : float) -> void:
	if can_dodge and Input.is_action_just_pressed("dodge"):
		start_dodge()

	if dodge_timer > -dodge_cooldown:
		dodge_timer -= delta
		if dodge_timer <= -dodge_cooldown:
			can_dodge = true
			
	if !can_move:
		return
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

		if !velocity.is_zero_approx() && input_vector.y != -1:
			animated_sprite.play("run_h")
		elif !velocity.is_zero_approx():
			animated_sprite.play("run_v_up")
		else:
			animated_sprite.play("idle")

	move_and_slide()

func start_dodge() -> void:
	can_dodge = false
	dodge_timer = dodge_duration


func _on_health_component_health_changed(amount: Variant) -> void:
	# Check if the amount is negative (indicating a health decrease)
	if amount < 0:
		camera.screen_shake()
		# Hurt animation: scale and change color to red briefly
		#var tween := get_tree().create_tween()
		
		# Scale the sprite to create a "shake" effect
		#tween.tween_property(animated_sprite, "scale", Vector2(), 1).set_trans(Tween.TRANS_BOUNCE)
		

		# Change the color modulate to red to indicate damage
		#tween.tween_property(animated_sprite, "modulate", Color.RED, 1).set_trans(Tween.TRANS_BOUNCE)
		
		# Start the tween animation
		#tween.play()


func _on_health_component_died() -> void:
	can_move = false
	animated_sprite.play("die")
	death_screen.fade_in()
