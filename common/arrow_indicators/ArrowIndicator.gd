extends Node2D

# Variables
@export var target: Node2D = null  # The object this arrow will point to
@export var arrow_sprite: Sprite2D = null  # Reference to the Sprite node
@export var screen_margin: float = 20.0  # Margin from screen edge when off-screen
@export var camera: Camera2D = null  # Reference to the camera
@export var player: Player = null
@export var at_player_scale: float = 0.4
@export var lerp_speed_to_player: float = 10

var finished_travel := false


# Function to set the custom arrow sprite
func set_custom_arrow(texture: Texture):
	if arrow_sprite:
		arrow_sprite.texture = texture


# Called when the node enters the scene
func _ready():
	#scale = Vector2(0.4, 0.4) # Scale down for a good texture size
	arrow_sprite = $Sprite2D  # Ensure we have the sprite reference
	if not camera:
		camera = get_viewport().get_camera_2d()  # Get camera reference


# This will update the arrow's position and visibility each frame
func _process(delta):
	if not target or not camera:
		return

	# Get the target's global position
	var target_position = target.global_position

	# Convert the target's world position to screen coordinates
	var screen_position = world_to_screen(target_position)

	# Get the screen boundaries (without margins)
	var screen_size = get_viewport_rect().size
	var screen_rect = Rect2(
		Vector2.ZERO, screen_size - Vector2(screen_margin, screen_margin) * camera.zoom
	)

	# Check if the target is in view (within the camera's screen)
	if screen_rect.has_point(screen_position):
		# Target is in view, hover over the target
		global_position = lerp(
			global_position, target_position + Vector2(0, -screen_margin), delta * 5
		)
		look_at(target_position)
		scale = lerp(scale, Vector2.ONE, delta)
		finished_travel = false
	else:
		# Target is off-screen, point the arrow towards it

		var direction = (target_position - player.global_position).normalized()
		scale = lerp(scale, Vector2(at_player_scale, at_player_scale), delta * lerp_speed_to_player)

		var arrow_position = player.global_position + direction * 40

		if !finished_travel:
			global_position = lerp(global_position, arrow_position, delta * lerp_speed_to_player)
			if global_position.distance_to(arrow_position) < 10:
				finished_travel = true
		else:
			global_position = arrow_position

		look_at(target_position)


# Converts world position to screen coordinates
func world_to_screen(world_position: Vector2) -> Vector2:
	# Adjust world position by camera's offset (camera.global_position)
	return (world_position - camera.global_position) * camera.zoom + get_viewport().size * 0.5
