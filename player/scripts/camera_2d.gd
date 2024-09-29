extends Camera2D

var follow_strength: float = 50.0
var lerp_factor: float = 5.0  # A smaller factor ensures smoother transitions

@export var snap_distance: float = 100
@export var snap_offset: float = 2
@export var snap_hold_duration: float = 0.1  # Hold time in seconds before switching points

# Snapping directions in 8 directions plus the center
const snap_points: Array = [
	Vector2(0, -1),  # N
	Vector2(0.75, -0.75),  # NE
	Vector2(1, 0),  # E
	Vector2(0.75, 0.75),  # SE
	Vector2(0, 1),  # S
	Vector2(-0.75, 0.75),  # SW
	Vector2(-1, 0),  # W
	Vector2(-0.75, -0.75),  # NW
	Vector2(0, 0)  # Center
]

# Current target position the camera is moving towards
var current_target_position: Vector2 = Vector2()

# Timer for holding near a point
var current_snap_hold_time: float = 0.0
var previous_snap_point: Vector2 = Vector2()


func _ready() -> void:
	for point in snap_points:
		point *= snap_offset


func screen_shake(_intensity: float = 10.0, _duration: float = 0.5, _shakes: int = 5) -> void:
	pass


func move_camera_in_game(delta: float) -> void:
	var screen_center = get_viewport().get_visible_rect().size / 2
	var mouse_pos_2d = get_viewport().get_mouse_position()
	var mouse_offset = (mouse_pos_2d - screen_center) / get_viewport().get_visible_rect().size * 2

	# Calculate the closest snap point based on actual distances
	var closest_snap_point = snap_points[0]
	var closest_distance = mouse_offset.distance_to(snap_points[0])

	for snap_point in snap_points:
		var dist = mouse_offset.distance_to(snap_point)
		if dist < closest_distance:
			closest_distance = dist
			closest_snap_point = snap_point

	# Check if we're still hovering over the same snap point
	if closest_snap_point == previous_snap_point:
		# Increment the hold time
		current_snap_hold_time += delta

		# If the hold time exceeds the delay, switch to the new point
		if current_snap_hold_time >= snap_hold_duration:
			# Calculate the target position using the closest snap point and snap distance
			current_target_position = closest_snap_point * snap_distance
	else:
		# If we moved to a different snap point, reset the hold timer
		previous_snap_point = closest_snap_point
		current_snap_hold_time = 0.0

	# Smoothly move the camera towards the target position
	position = position.lerp(current_target_position, delta)


func _process(delta: float) -> void:
	move_camera_in_game(delta)
