extends TileMap

#Cell info
var cell_size = Vector2(16, 16)

# Tiles
var tile_outline = Vector2(17, 12)


#Objects that spawn at start (dont need respawn)
var dungeon= preload("res://Interaction/Prefabs/dungeonEntrance.tscn")
var tree = preload("res://Interaction/Prefabs/Tree.tscn")

func _ready():
	generate_tiles()

func generate_tiles():
	connectTiles(0)
	
	for position in GenerateMapVariables.map_Edge_cells:
		set_cell(2, position, 12, tile_outline)
	
	for position in GenerateMapVariables.random_Object_cells:
		var random_number = randi() % 16 + 1
		place_large_object_from_tile(random_number, position)
		
	for position in GenerateMapVariables.random_WaterObject_cells:
		var random_number = randi() % 5 + 1
		place_large_water_object_from_tile(random_number, position)
	
	#for position in GenerateMapVariables.random_tree_cells:
		#place_tree(position)
		
	for position in GenerateMapVariables.dungeon_cells:
		placeDungeon(position)


func placeRandomObject(list, pos):
	var random_index = randi() % list.size()
	set_cell(2, pos, 0, list[random_index])


func placeDungeon(pos):
	var dungeon_instance = dungeon.instantiate()
	dungeon_instance.position = map_to_local(pos)
	dungeon_instance.z_index = 1
	add_child(dungeon_instance)
	
func place_tree(pos):
	var tree_instance = tree.instantiate()
	tree_instance.position = map_to_local(pos)
	tree_instance.z_index = 1
	
	var sprite = tree_instance.get_node("Sprite2D")
	var new_texture = GenerateMapVariables.getRandomTreeSprite()
	sprite.texture = new_texture
	sprite.scale = Vector2(GenerateMapVariables.treeScale, GenerateMapVariables.treeScale)
	add_child(tree_instance)
		

	
func connectTiles(tileset):
	set_cells_terrain_connect(1, GenerateMapVariables.ground_cells, tileset, 0)
	#set_cells_terrain_connect(2, GenerateMapVariables.dirt_cells,tileset,4)
	set_cells_terrain_connect(1, GenerateMapVariables.Tree_cells, tileset, 2)
	set_cells_terrain_connect(0, GenerateMapVariables.water_cells, tileset, 1)
	
	#Testa WIlles här
	#set_cells_terrain_connect(1, GenerateMapVariables.ground_cells, tileset,5)
	#set_cells_terrain_connect(1, GenerateMapVariables.Tree_cells, tileset, 6)
	
func place_large_water_object_from_tile(objectID, center):
	var columns = 0
	var rows = 0
	var start = null

	match objectID:
		1:
			start = Vector2(8, 4)
			columns = 4
			rows = 4
		2:  
			start = Vector2(10, 11)  
			columns = 4 
			rows = 3
		3:
			pass
		4:
			start = Vector2(4, 17)  
			columns = 2
			rows = 2
		5:
			start = Vector2(8, 17)  
			columns = 2 
			rows = 2
	for x in range(columns):
		for y in range(rows):
			var tile_position = Vector2(start.x + x, start.y + y)
			set_cell(2, Vector2i(center.x + x, center.y + y), 16, tile_position)
	
func place_large_object_from_tile(objectID, center):
	var columns = 0
	var rows = 0
	var start = null

	match objectID:
		1:
			start = Vector2(0, 0)
			columns = 4
			rows = 4
		2:  
			start = Vector2(4, 0)  
			columns = 4 
			rows = 4
		3:
			start = Vector2(8, 0)  
			columns = 4 
			rows = 4
		4:
			start = Vector2(12, 0)  
			columns = 4 
			rows = 4
		5:
			start = Vector2(0, 4)  
			columns = 4 
			rows = 4
		6:
			start = Vector2(4, 4)  
			columns = 4 
			rows = 4
		7:
			start = Vector2(8, 4)  
			columns = 4 
			rows = 4
		8:
			start = Vector2(12, 4)  
			columns = 4 
			rows = 4
		9:
			start = Vector2(0, 8)  
			columns = 4 
			rows = 3
		10:
			start = Vector2(4, 8)  
			columns = 4 
			rows = 3
		11:
			start = Vector2(8, 8)  
			columns = 4 
			rows = 3
		12:
			start = Vector2(12, 8)  
			columns = 4 
			rows = 3
		13:
			start = Vector2(0, 11)  
			columns = 4 
			rows = 4
		14:
			start = Vector2(4, 11)  
			columns = 3 
			rows = 4																							
		15:
			start = Vector2(7, 11)  
			columns = 3 
			rows = 3
		16: 
			start = Vector2(10, 11)  
			columns = 4 
			rows = 3
	for x in range(columns):
		for y in range(rows):
			var tile_position = Vector2(start.x + x, start.y + y)
			set_cell(2, Vector2i(center.x + x, center.y + y), 15, tile_position)
