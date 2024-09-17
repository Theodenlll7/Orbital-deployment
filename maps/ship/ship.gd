extends Node2D

@onready var interaction_area := $InteractionArea

@onready var arrow_to_ship_canvas = $CanvasLayer
@onready var direction_line := arrow_to_ship_canvas.get_node("Line2D")
@onready var player := $"../Player"
@onready var camera := player.get_node("Camera2D")
var max_distance = 350.0

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact") 
	arrow_to_ship_canvas.visible = false

func _on_interact():
	GameVariables.reparirShip()

func getPlayerLocation():
	return player.position

func _process(delta: float) -> void:
	var direction_to_ship = getPlayerLocation().distance_to(self.position)
	
	if direction_to_ship > max_distance:
		arrow_to_ship_canvas.visible = true
		update_direction(getPlayerLocation(), self.position)
	else:
		arrow_to_ship_canvas.visible=false
	
func update_direction(player_pos, ship_pos):
	var camera_transform = camera.get_global_transform_with_canvas().affine_inverse()
	var player_screen_pos = camera_transform* player_pos
	var ship_screen_pos = camera_transform* ship_pos

	var direction = (ship_screen_pos - player_screen_pos).normalized()

	var screen_size = get_viewport().size

	var line_start = Vector2(screen_size/2)

	var x_max_pos = 430
	var y_max_pos = 220
	
	if player_pos.x > x_max_pos: 
		line_start.x -=x_max_pos*2
	elif player_pos.x < -x_max_pos:
		line_start.x +=x_max_pos*2
	else:
		line_start.x -=player_pos.x*2
	
	if player_pos.y > y_max_pos:
		line_start.y -=y_max_pos*2
	elif player_pos.y < -y_max_pos:
		line_start.y +=y_max_pos*2
	else:
		line_start.y -=player_pos.y*2
	
	var line_end = line_start + direction * 100
	direction_line.clear_points()
	direction_line.add_point(line_start)
	direction_line.add_point(line_end) 

	# Draw the arrowhead
	var arrowhead_size = 20.0
	var angle = direction.angle()  # Get the angle of the direction vector

	# Calculate the positions of the arrowhead points
	var arrowhead_left = line_end + direction.rotated(-4*PI/5) * arrowhead_size
	var arrowhead_right = line_end + direction.rotated(4*PI/5) * arrowhead_size

	# Draw the arrowhead
	direction_line.add_point(arrowhead_left)
	direction_line.add_point(line_end)
	direction_line.add_point(arrowhead_right)
	direction_line.add_point(line_end)
