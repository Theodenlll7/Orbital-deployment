class_name BullChargeAttack extends MTAction

@export var charge_speed: float = 250  # Speed of the charge
@export var charge_duration: float = 1.5  # Duration of the charge in seconds
@export var windup_time: float = 0.5  # Time to "wind up" before charging

var charge_direction: Vector2
var is_charging: bool = false
var charge_timer: float = 0.0
var windup_timer: float = 0.0


func tick(blackboard: Blackboard) -> int:
	var actor = blackboard.actor as CharacterBody2D

	# Get target position from blackboard
	var target = blackboard.get_value("target")
	if !target:
		return FAILURE

	var target_position = target.global_position

	# If we're not charging yet, wind up the attack
	if !is_charging:
		if windup_timer < windup_time:
			# Face towards the target and build anticipation
			charge_direction = (target_position - actor.global_position).normalized()
			windup_timer += blackboard.delta_time
			return RUNNING
		else:
			# After windup, start charging
			is_charging = true
			charge_timer = 0.0
			emit_sound()

	# Perform the charging action
	if is_charging:
		charge_timer += blackboard.delta_time
		if charge_timer <= charge_duration:
			# Move the actor in the charge direction
			actor.velocity = charge_direction * charge_speed
			return RUNNING
		else:
			# Charge completed
			is_charging = false
			windup_timer = 0.0  # Reset windup for the next charge
			return SUCCESS

	return FAILURE

func emit_sound() -> void:
	var sound: AudioStream = preload("res://enemies/assets/audio/spider/spider_attack.ogg")
	var player = AudioStreamPlayer.new()
	
	player.stream = sound
	player.bus = "Weapon"
	
	add_child(player)
	
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
