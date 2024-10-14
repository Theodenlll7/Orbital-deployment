extends TileMap

#Cell info
var cell_size = Vector2(16, 16)

# Tiles
var tile_outline = Vector2(1, 9)

func _ready():
	generate_tiles()

func generate_tiles():
	connectTiles(1)
	
	for position in GenerateMapVariables.map_Edge_cells:
		set_cell(2, position, 2, tile_outline)
	
	for position in GenerateMapVariables.random_Object_cells:
		var random_number = randi() % 16 + 1
		place_large_object_from_new_tile(random_number, position)
		
func placeRandomObject(list, pos):
	var random_index = randi() % list.size()
	set_cell(2, pos, 0, list[random_index])

func connectTiles(tileset):
	set_cells_terrain_connect(1, GenerateMapVariables.ground_cells, tileset, 0)
	#set_cells_terrain_connect(2, GenerateMapVariables.dirt_cells,tileset,4)
	set_cells_terrain_connect(2, GenerateMapVariables.ground2_cells, tileset, 5)
	set_cells_terrain_connect(0, GenerateMapVariables.entire_map_cells, tileset, 3)
	
func place_large_object_from_new_tile(objectID, center):
	var columns = 0
	var rows = 0
	var start = null

	if GenerateMapVariables.current_tree_chance <randf():
		var random_numb = randf()
		if random_numb < 0.5:
				start = Vector2(7, 8)
				columns = 2
				rows = 3
		else:
				start = Vector2(9, 8)
				columns = 2
				rows = 3
			
	else:
		match objectID:
			1:
				start = Vector2(0, 0)
				columns = 2
				rows = 2
			2:  
				start = Vector2(0, 2)  
				columns = 2
				rows = 2
			3:
				start = Vector2(2, 2)  
				columns = 2
				rows = 2
			4:
				start = Vector2(4, 2)  
				columns = 2
				rows = 2
			5:
				start = Vector2(0, 4)  
				columns = 1
				rows = 1
			6:
				start = Vector2(6, 2)  
				columns = 1
				rows = 1
			7:
				start = Vector2(6, 3)  
				columns = 1
				rows = 1
			8:
				start = Vector2(0, 4)  
				columns = 1
				rows = 1
			9:
				start = Vector2(3, 4)  
				columns = 1
				rows = 1
			10:
				start = Vector2(4, 4)  
				columns = 1
				rows = 1
			11:
				start = Vector2(9, 5)  
				columns = 1
				rows = 1
			12:
				start = Vector2(10, 6)  
				columns = 1
				rows = 1
			13:
				start = Vector2(10, 7)  
				columns = 4 
				rows = 1
			14:
				start = Vector2(13, 8)  
				columns = 1
				rows = 2																						
			15:
				start = Vector2(4, 2)  
				columns = 2
				rows = 2
			16: 
				start = Vector2(0, 2)  
				columns = 2
				rows = 2
	for x in range(columns):
		for y in range(rows):
			var tile_position = Vector2(start.x + x, start.y + y)
			set_cell(2, Vector2i(center.x + x, center.y + y), 2, tile_position)
