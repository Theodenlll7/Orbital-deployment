class_name AreaEffectBaker extends Node

@export var target_terrain_id: int
@export var area_effect: AreaEffect
@export var edge_margin: float = 5

var tilemap_start: Vector2i
var tilemap_end: Vector2i

@onready var tilemap = get_parent() as TileMapLayer


# Greedy meshing algorithm to generate merged water areas
func generate_areas() -> void:
	tilemap_start = tilemap.get_used_rect().position
	tilemap_end = tilemap_start + tilemap.get_used_rect().size
	var cell_size = tilemap.tile_set.tile_size
	if Engine.is_editor_hint():
		cell_size = Vector2(16, 16)
	else:
		cell_size = tilemap.tile_set.tile_size
	var processed = []

	# Initialize processed array
	for x in range(tilemap_end.x - tilemap_start.x):
		processed.append([])
		for y in range(tilemap_end.y - tilemap_start.y):
			processed[x].append(false)

	# Remove existing children (to avoid duplication)
	for child in get_children():
		if child is Area2D:
			remove_child(child)
			child.queue_free()

	# Apply greedy meshing algorithm
	for x in range(tilemap_start.x, tilemap_end.x):
		for y in range(tilemap_start.y, tilemap_end.y):
			if processed[x - tilemap_start.x][y - tilemap_start.y]:
				continue

			var tile_pos = Vector2i(x, y)
			var tile_terrain = get_terrain(tile_pos)

			# Only process water tiles
			if tile_terrain == target_terrain_id:
				# Find the largest possible rectangle of adjacent water tiles
				var area_rect = find_largest_rectangle(x, y, processed)

				# Create the Area2D for this rectangle
				var area = Area2D.new()
				area.body_entered.connect(area_effect._on_body_entered)
				area.body_exited.connect(area_effect._on_body_exited)
				add_child(area)
				area.set_collision_layer_value(1, false)
				area.set_collision_mask_value(2, true)
				area.collision_priority = 0.1

				# Check for margins on each side
				var left_margin = check_x_margin(Vector2i(x - 1, y))
				var right_margin = check_x_margin(Vector2i(x + area_rect.x, y))
				var top_margin = check_y_margin(x, y - 1, area_rect.x)
				var bottom_margin = check_y_margin(x, y + area_rect.y, area_rect.x)

				# Calculate the size of the area with the margin adjustments
				var adjusted_width = area_rect.x * cell_size.x - (left_margin + right_margin)
				var adjusted_height = area_rect.y * cell_size.y - (top_margin + bottom_margin)

				# Ensure we don't shrink below zero or negative size
				adjusted_width = max(adjusted_width, 0)
				adjusted_height = max(adjusted_height, 0)

				# Set the size of the collision shape
				var collision_shape = CollisionShape2D.new()
				collision_shape.shape = RectangleShape2D.new()
				collision_shape.shape.size = Vector2(adjusted_width, adjusted_height)
				area.add_child(collision_shape)

				# Position the Area2D in the center of the rectangle
				var local_position = tilemap.map_to_local(
					Vector2(x + area_rect.x / 2, y + area_rect.y / 2)
				)
				if area_rect.x % 2 == 0:
					local_position.x -= cell_size.x / 2
				if area_rect.y % 2 == 0:
					local_position.y -= cell_size.y / 2

				# Offset the position by the margins
				local_position.x += left_margin - right_margin
				local_position.y += top_margin - bottom_margin

				area.z_index = 10

				area.position = local_position


# Function to find the largest rectangle starting at (x, y)
func find_largest_rectangle(start_x: int, start_y: int, processed: Array) -> Vector2i:
	var tilemap_size = tilemap.get_used_rect().size

	# Find the largest width
	var width = 0
	for x in range(start_x, tilemap_size.x):
		var tile_pos = Vector2i(x, start_y)
		var tile_terrain = get_terrain(tile_pos)
		if (
			tile_terrain != target_terrain_id
			or processed[x - tilemap_start.x][start_y - tilemap_start.y]
		):
			break
		processed[x - tilemap_start.x][start_y - tilemap_start.y] = true
		width += 1

	# Find the largest height that can be merged
	var height = 1
	for y in range(start_y + 1, tilemap_size.y):
		# Ensure all tiles in this row can be merged
		var can_merge = true
		for x in range(start_x, start_x + width):
			var tile_pos = Vector2i(x, y)
			var tile_terrain = get_terrain(tile_pos)
			if (
				tile_terrain != target_terrain_id
				or processed[x - tilemap_start.x][y - tilemap_start.y]
			):
				can_merge = false
				break
		if not can_merge:
			break

		for x in range(start_x, start_x + width):
			processed[x - tilemap_start.x][y - tilemap_start.y] = true
		height += 1

	return Vector2i(width, height)


func get_terrain(tile_pos: Vector2i):
	var tile_data = tilemap.get_cell_tile_data(tile_pos)
	if !tile_data:
		return null
	return tile_data.terrain_set


func is_inside_tilemap(tile_pos: Vector2i) -> bool:
	return (
		tile_pos.x >= tilemap_start.x
		and tile_pos.x < tilemap_end.x
		and tile_pos.y >= tilemap_start.y
		and tile_pos.y < tilemap_end.y
	)


# Function to check if a margin should be applied based on adjacent terrain
func check_x_margin(tile_pos: Vector2i) -> float:
	# If the tile position is outside the tilemap bounds or is not the target terrain, apply the margin
	if not is_inside_tilemap(tile_pos) or get_terrain(tile_pos) != target_terrain_id:
		return edge_margin
	return 0.0


func check_y_margin(start_x: int, y: int, width: int) -> float:
	for x in range(start_x, start_x + width):
		if (
			not is_inside_tilemap(Vector2i(x, y))
			or get_terrain(Vector2i(x, y)) != target_terrain_id
		):
			return edge_margin
	return 0.0


func _ready() -> void:
	generate_areas()
