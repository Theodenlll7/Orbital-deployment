extends TileMap

#Cell info
var cell_size = Vector2(16, 16)

# Tiles
var tile_outline = Vector2(10, 4)

var land_objects = [Vector2(7,0), Vector2(8,0), Vector2(9,0), Vector2(7,1), Vector2(6,3),
 Vector2(7,3),Vector2(8,3),Vector2(9,3),Vector2(8,4),Vector2(9,4),Vector2(7,6),Vector2(9,6),
Vector2(10,6),
]

var water_objects = [Vector2(7,4), Vector2(11,3), Vector2(7,0), Vector2(12,6),Vector2(6,6)
]

var lan_space_objects = [Vector2(6,0), Vector2(13,4), Vector2(13,16), Vector2(4,10), Vector2(9,10), Vector2(11,10)]

#Objects that spawn at start (dont need respawn)
var dungeon= preload("res://Interaction/Prefabs/dungeonEntrance.tscn")
var tree = preload("res://Interaction/Prefabs/Tree.tscn")
var tree2 = preload("res://Interaction/Prefabs/Tree2.tscn")

func _ready():
	generate_tiles()

func generate_tiles():
	connectTiles(3)
	
	for position in GenerateMapVariables.map_Edge_cells:
		set_cell(2, position, 0, tile_outline)
		
	for position in GenerateMapVariables.random_Object_cells:
		place_tree(position)
		
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
	var random_number = randf()
	if random_number < 0.5:
		var tree_instance = tree.instantiate()
		tree_instance.position = map_to_local(pos)
		tree_instance.z_index = 1
		add_child(tree_instance)
	else:
		var tree_instance = tree2.instantiate()
		tree_instance.position = map_to_local(pos)
		tree_instance.z_index = 1
		add_child(tree_instance) 
		

	
func connectTiles(tileset):
	set_cells_terrain_connect(1, GenerateMapVariables.ground_cells, tileset, 0)
	set_cells_terrain_connect(2, GenerateMapVariables.Tree_cells, tileset, 3)
	set_cells_terrain_connect(0, GenerateMapVariables.water_cells, tileset, 1)
	
