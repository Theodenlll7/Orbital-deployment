extends Node2D

@onready var label = $Label as Label

var amount: int = 0

@export var pop_time: float = 0.2
@export var pop_scale: float = 1.8
@export var decay_time: float = 0.6
@export var move_distance: float = 50.0
@export var move_randomness: float = 20.0
@export var spawn_offset: float = 10.0
@export var rotation_angle: float = 15.0

@export var negative_color := Color.WHITE_SMOKE
@export var positive_color := Color.FOREST_GREEN


func _ready():
	# Apply initial spawn offset
	position += Vector2(
		randi_range(-spawn_offset, spawn_offset), randi_range(-spawn_offset, spawn_offset)
	)

	# Set the label text and color based on the amount
	label.text = str(abs(amount))
	var color: Color
	if amount < 0:
		color = negative_color
	else:
		color = positive_color
	var fade_color: Color = color
	fade_color.a = 0

	label.set("theme_override_colors/font_color", negative_color)
	var tween = create_tween()
	tween.bind_node(self)
	tween.set_parallel()
	# Pop animation
	tween.tween_property(self, "scale", Vector2.ONE * pop_scale, pop_time).set_trans(
		Tween.TRANS_BOUNCE
	)
	(
		tween
		. tween_property(self, "scale", Vector2.ONE, pop_time)
		. set_trans(Tween.TRANS_BOUNCE)
		. set_delay(pop_time)
	)

	# Randomize movement direction while floating up
	var end_position = (
		position + Vector2(randi_range(-move_randomness, move_randomness), -move_distance)
	)
	(
		tween
		. tween_property(self, "position", end_position, pop_time + decay_time)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_OUT)
	)

	var end_rotation = rotation_angle if randi_range(0, 1) == 0 else -rotation_angle
	(
		tween
		. tween_property(self, "rotation_degrees", end_rotation, pop_time + decay_time)
		. set_trans(Tween.TRANS_SINE)
		. set_ease(Tween.EASE_IN_OUT)
	)

	# Fade out animation
	(
		tween
		. tween_property(label, "theme_override_colors/font_color", fade_color, decay_time)
		. set_trans(Tween.TRANS_LINEAR)
		. set_ease(Tween.EASE_IN)
		. set_delay(pop_time)
	)
#
	# Rotation animation
	tween.set_parallel(false)
	# Free the node after the animation
	tween.tween_callback(Callable(self, "queue_free"))


# Utility function to get a random integer in a range
func randi_range(min: int, max: int) -> int:
	return randi() % (max - min + 1) + min
