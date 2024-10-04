extends TileMapLayer

@export var navigation_layer: int = 0
@export var obstacle_layers: Array[TileMapLayer]
@export var physics_layers: Array[int] = [0]


func _tile_data_runtime_update(_coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_navigation_polygon(0, null)


func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	for obstacles in obstacle_layers:
		for id in physics_layers:
			if (
				coords in obstacles.get_used_cells()
				and obstacles.get_cell_tile_data(coords).get_collision_polygons_count(id) != 0
			):
				return true
	return false
