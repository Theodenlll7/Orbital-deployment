extends TileMap

@export var width = 250
@export var height = 250
@export var object_placement_probability = 0.01
@export var different_grass_probability = 0.09
@export var min_Path_Length = 6
@export var max_Path_Length = 16

var center_offset = Vector2(-width / 2, -height / 2)


var tile_grass = Vector2(3, 0)   
var tile_grass2 = Vector2(3, 1)
var tile_grass3 = Vector2(5, 0)
var tile_grass_single_tile = Vector2(7, 0)

var sand_tile = Vector2(5, 2)
var sand_tile2 = Vector2(5, 5)
var sand_tile3 = Vector2(6, 5)
var sand_tile4 = Vector2(7, 5)
var sand_tile5 = Vector2(4, 4)
var sand_tile6 = Vector2(5, 4)

var sand_HU = Vector2(5, 1)
var sand_HD = Vector2(5, 3)
var sand_VR = Vector2(7, 2)
var sand_VL = Vector2(4, 2)

var sand_TR_corner = Vector2(7, 1)
var sand_TL_corner = Vector2(4, 1)
var sand_BR_corner = Vector2(7, 3)
var sand_BL_corner = Vector2(4, 3)

var sand_single_tile = Vector2(6, 2)

var tile_outline = Vector2(6, 6) 

var stone1 = Vector2(6, 6)
var stone2 = Vector2(0, 4)
var stone3 = Vector2(7, 6)
var mushroom1 = Vector2(1, 4)
var mushroom2 = Vector2(2, 4)
var flower1 = Vector2(3, 4)
var flower2 = Vector2(2, 5)
var plant1 = Vector2(0, 5)
var plant2 = Vector2(1, 5)
var plant3 = Vector2(3, 5)
var plant4 = Vector2(0, 6)
var plant5 = Vector2(1, 6)
var plant6 = Vector2(2, 6)
var plant7 = Vector2(3, 6)
var plant8 = Vector2(4, 6)
var plant9 = Vector2(0, 7)

var path_coordinates = []
var path_outline_vertical_left = []
var path_outline_vertical_right = []
var path_outline_horizontal_down = []
var path_outline_horizontal_up = []

var path_top_left_corner = []
var path_top_right_corner = []
var path_bot_left_corner = []
var path_bot_right_corner = []

enum Direction {UP,DOWN,LEFT,RIGHT}
var sands = [sand_tile,sand_tile2,sand_tile3,sand_tile4,sand_tile5,sand_tile6,]
var objects = [stone1,stone2,stone3,mushroom1,mushroom2,flower1,flower2,plant1,plant2,plant3,plant4,plant5,plant6,plant7,plant8,plant9]
var grass = [tile_grass, tile_grass2, tile_grass3]
func _ready():
	path_coordinates = generateFullPath()
	generate_tiles()

func check_coords(coordList, coordx, coordy):
	for coord in coordList:
		if coord.x == coordx and coord.y == coordy:
			return true
	return false

func generate_tiles():
	for x in range(width):
		for y in range(height):
			var map_x = center_offset.x + x
			var map_y = center_offset.y + y
			if x == 0 or x == width - 1 or y == 0 or y == height - 1:
				set_cell(0, Vector2i(map_x, map_y), 0, tile_outline)
			else:
				var is_path = check_coords(path_coordinates, map_x, map_y)
				var is_path_HD = check_coords(path_outline_horizontal_down, map_x, map_y)
				var is_path_HU = check_coords(path_outline_horizontal_up, map_x, map_y)
				var is_path_VL = check_coords(path_outline_vertical_left, map_x, map_y)
				var is_path_VR = check_coords(path_outline_vertical_right, map_x, map_y)
				var is_path_TL_corner = check_coords(path_top_left_corner, map_x, map_y)
				var is_path_TR_corner = check_coords(path_top_right_corner, map_x, map_y)
				var is_path_BL_corner = check_coords(path_bot_left_corner, map_x, map_y)
				var is_path_BR_corner = check_coords(path_bot_right_corner, map_x, map_y)
				
				if is_path:
					set_cell(0, Vector2i(map_x, map_y), 0, get_random_sand())
				elif is_path_HD:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_HD)
				elif is_path_HU:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_HU)
				elif is_path_VL:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_VL)
				elif is_path_VR:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_VR)
				elif is_path_TL_corner:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_TL_corner)
				elif is_path_TR_corner:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_TR_corner)
				elif is_path_BL_corner:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_BL_corner)
				elif is_path_BR_corner:
					set_cell(0, Vector2i(map_x, map_y), 0, sand_BR_corner)                    
				elif randf() < object_placement_probability:
					set_cell(0, Vector2i(map_x, map_y), 0, tile_grass_single_tile)
				else:    
					if(randf()< different_grass_probability):
						set_cell(0, Vector2i(map_x, map_y), 0, get_random_grass())
					else:
						set_cell(0, Vector2i(map_x, map_y), 0, tile_grass)
				
				if randf() < object_placement_probability:  
					set_cell(1, Vector2i(map_x, map_y), 0, get_random_object())

func get_random_object():
	var index = randi() % objects.size()
	return objects[index]

func get_random_sand():
	var index = randi() % sands.size()
	return sands[index]
func get_random_grass():
	var index = randi() % grass.size()
	return grass[index]
func generateFullPath():
	var start = Vector2(0, 0)  # Starting point
	var forward_path = generatePath(start, true)
	var backward_path = generatePath(start, false)
	
	# Remove the starting point from the backward path to avoid duplication
	backward_path.pop_back()
	
	return backward_path + forward_path

func generatePath(start, forward):
	var path = [start]  # Initialize path with the starting point
	var current_position = start
	var last_direction = null  # To keep track of the last direction
	var first_direction = null
	var up = 0
	var down = 1
	var left = 2
	var right = 3
	
	while current_position.x > -width / 2 and current_position.x < width / 2 and current_position.y > -height / 2 and current_position.y < height / 2:
		var direction = get_new_direction(last_direction, first_direction)
		if last_direction == null and first_direction == null:
			first_direction = direction
		
		if not forward:
			direction = opposite_direction(direction)
		
		var length_of_direction = randi_range(min_Path_Length, max_Path_Length)
		var extra_tile_pos = current_position

		if last_direction != null:
			if last_direction == down:
				if direction == right or direction == left:
					extra_tile_pos.y += 1
					path_outline_horizontal_down.append(extra_tile_pos)
					if direction == right:
						extra_tile_pos.x -= 1
						path_bot_left_corner.append(extra_tile_pos)
					else:
						extra_tile_pos.x += 1
						path_bot_right_corner.append(extra_tile_pos)
			elif last_direction == up:
				if direction == right or direction == left:
					extra_tile_pos.y -= 1
					path_outline_horizontal_up.append(extra_tile_pos)
					if direction == right:
						extra_tile_pos.x -= 1
						path_top_left_corner.append(extra_tile_pos)
					else:
						extra_tile_pos.x += 1
						path_top_right_corner.append(extra_tile_pos)
			elif last_direction == right:
				if direction == down or direction == up:
					extra_tile_pos.x += 1
					path_outline_vertical_right.append(extra_tile_pos)
					if direction == down:
						extra_tile_pos.y -= 1
						path_top_right_corner.append(extra_tile_pos)
					else:
						extra_tile_pos.y += 1
						path_bot_right_corner.append(extra_tile_pos)
			elif last_direction == left:
				if direction == down or direction == up:
					extra_tile_pos.x -= 1
					path_outline_vertical_left.append(extra_tile_pos)
					if direction == down:
						extra_tile_pos.y -= 1
						path_top_left_corner.append(extra_tile_pos)
					else:
						extra_tile_pos.y += 1
						path_bot_left_corner.append(extra_tile_pos)

		for i in range(length_of_direction):
			current_position += get_direction_vector(direction)
			if current_position.x <= -width / 2 or current_position.x >= width / 2 or current_position.y <= -height / 2 or current_position.y >= height / 2:
				break  # Exit the loop if the path reaches the edge of the map
			path.append(current_position)
			store_coordinate(current_position, direction)
			extra_tile_pos = current_position + get_direction_vector(direction)
		last_direction = direction

		if current_position.x <= -width / 2 or current_position.x >= width / 2 or current_position.y <= -height / 2 or current_position.y >= height / 2:
			break  # Exit the loop if the path reaches the edge of the map

	return path

func get_new_direction(last_direction, first_direction):
	var directions = [Direction.UP, Direction.DOWN, Direction.LEFT, Direction.RIGHT]
	if last_direction != null:
		directions.erase(opposite_direction(last_direction))
		directions.erase(last_direction)
		
	if first_direction == Direction.UP:
		directions.erase(Direction.DOWN)
	elif first_direction == Direction.DOWN:
		directions.erase(Direction.UP)
	elif first_direction == Direction.RIGHT:
		directions.erase(Direction.LEFT)
	elif first_direction == Direction.LEFT:
		directions.erase(Direction.RIGHT)
	
	return directions[randi() % directions.size()]

func get_direction_vector(direction):
	match direction:
		Direction.UP:
			return Vector2(0, -1)
		Direction.DOWN:
			return Vector2(0, 1)
		Direction.LEFT:
			return Vector2(-1, 0)
		Direction.RIGHT:
			return Vector2(1, 0)

func opposite_direction(direction):
	match direction:
		Direction.UP:
			return Direction.DOWN
		Direction.DOWN:
			return Direction.UP
		Direction.LEFT:
			return Direction.RIGHT
		Direction.RIGHT:
			return Direction.LEFT

func store_coordinate(coord, direction):
	match direction:
		Direction.UP:
			coord.x +=1
			path_outline_vertical_right.append(coord)
			coord.x -=2
			path_outline_vertical_left.append(coord)
		Direction.DOWN:
			coord.x +=1
			path_outline_vertical_right.append(coord)
			coord.x -=2
			path_outline_vertical_left.append(coord)
		Direction.LEFT:
			coord.y +=1
			path_outline_horizontal_down.append(coord)
			coord.y -=2
			path_outline_horizontal_up.append(coord)
		Direction.RIGHT:
			coord.y +=1
			path_outline_horizontal_down.append(coord)
			coord.y -=2
			path_outline_horizontal_up.append(coord)
