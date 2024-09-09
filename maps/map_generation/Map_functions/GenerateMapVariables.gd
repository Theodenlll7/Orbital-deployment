extends Node2D

@export var width = 200
@export var height = 200
@export var spawnArea_size = 20
@export var randomObjectChance = 0.005
@export var randomTreeChance = 0.001
@export var randomDungeon = 0.0001

@export var treeScale = 1.2
@export var treeRespawnTime = 25

var center_offset = Vector2(-width / 2, -height / 2)
const LAND_CAP = 0.2


#Variables for spawning
var max_chest_count = 10
var chests = []

#Information_Arrays
var dont_place_here = []
var water_is_here = []

#Generation_Arrays
var ground_cells = []
var water_cells = []
var dirt_cells=[]
var path_cells = []
var Tree_cells = []

var map_Edge_cells = []
var random_Object_cells = []
var random_WaterObject_cells = []
var random_tree_cells=[]
var dungeon_cells = []

var pod_positions = []
@export var numberOfPods = 3
@export var podDistanceBetween = 30
var podCount = numberOfPods-1


#Cell info
var cell_size = Vector2(16, 16)

# Noise
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var noise = FastNoiseLite.new()

func _ready():
	randomize()
	altitude.seed = randi()
	noise.seed = randi()
	altitude.frequency = 0.01
	generate_cells()

func generate_cells():
	for x in range(width):
		for y in range(height):
			var map_x = center_offset.x + x
			var map_y = center_offset.y + y
			
			var alt = altitude.get_noise_2d(map_x, map_y)
			var moist = moisture.get_noise_2d(map_x, map_y)
			var temp = temperature.get_noise_2d(map_x, map_y)
			water_cells.append(Vector2i(map_x, map_y))
			
			
			if x == 0 or x == width-1 or y == 0 or y == height-1:
				map_Edge_cells.append(Vector2i(map_x, map_y))
			else:
				var distance_to_center = Vector2(map_x, map_y).length()
				if distance_to_center <= spawnArea_size:
					ground_cells.append(Vector2i(map_x, map_y))
				else:
					if alt < LAND_CAP:
						ground_cells.append(Vector2i(map_x, map_y))
						if randf() < randomObjectChance:
							if checkToCloseToMapEdge(Vector2(map_x, map_y),10) or isPosCloseToObjects(Vector2(map_x, map_y), random_Object_cells) or isPosCloseToObjects(Vector2(map_x, map_y), water_is_here):
								pass
							else:
								random_Object_cells.append(Vector2i(map_x, map_y))
						if randf() < randomTreeChance and !between(temp, 0.2, 0.6) and !isPosCloseToObjects(Vector2(map_x, map_y), water_is_here):
							random_tree_cells.append(Vector2i(map_x, map_y))
						if between(temp, 0.2, 0.6):
							dont_place_here.append(Vector2i(map_x, map_y))
							Tree_cells.append(Vector2i(map_x, map_y))
						elif between(alt, 0.1, 0.9):
							if between(moist, 0, 0.4) and between(temp, 0.2, 0.6):
								dirt_cells.append(Vector2i(map_x, map_y))
						elif randf()< randomDungeon: 
							dungeon_cells.append(Vector2i(map_x, map_y))
					else: 
						water_is_here.append(Vector2i(map_x, map_y))		
						if randf() < randomObjectChance:
							if checkToCloseToMapEdge(Vector2(map_x, map_y),10) or isPosCloseToObjects(Vector2(map_x, map_y),random_WaterObject_cells)or isPosCloseToObjects(Vector2(map_x, map_y),ground_cells):
								pass
							else:
								random_WaterObject_cells.append(Vector2i(map_x, map_y))
						#water_cells.append(Vector2i(map_x, map_y))

					#elif between(alt, 0.2, 0.25):
						#shallow_water_cells.append(Vector2i(map_x, map_y))

func isPosCloseToObjects(pos, list):
	for position in list:
		if Vector2(pos).distance_to(Vector2(position))<7:
				return true
	return false
	
func checkToCloseToMapEdge(pos, maxDistance):
	var Min = -width / 2
	var Max = width / 2
	
	var y_vectorMax = Vector2(0,Max)
	var y_vectorMin =  Vector2(0,Min)
	
	var x_vectorMax = Vector2(Max,0)
	var x_vectorMin =  Vector2(Min,0)
	
	var tempXVec = Vector2(pos.x,0)
	var tempYVec = Vector2(0,pos.y)
	
	if tempXVec.distance_to(x_vectorMax)<maxDistance or tempXVec.distance_to(x_vectorMin)<maxDistance:
		return true
	if tempYVec.distance_to(y_vectorMax)<maxDistance or tempXVec.distance_to(y_vectorMin)<maxDistance:
		return true
	return false

func spawn_objects(scene: PackedScene, distance: float, group: String = "", spawn_count: int = 1):
	var object_count = 0
	if group != "":
		object_count = get_tree().get_nodes_in_group(group).size()
	var map_objects = get_tree().get_nodes_in_group("map_objects")

	if object_count >= spawn_count:
		return

	var attempts = 0
	while object_count < spawn_count and attempts < 100:
		attempts += 1
		var spawn_location = get_spawn_location()

		var can_place = true
		for object in map_objects:
			if spawn_location.distance_to(object.position)<distance:
				can_place = false
				break
		if can_place:
			object_count += 1
			map_objects.push_back(place_object(spawn_location, scene, group))

func place_object(pos: Vector2, scene: PackedScene, group: String):
	var instance = scene.instantiate()
	instance.position = pos
	instance.z_index = 1
	if group != "":
		instance.add_to_group(group)
	instance.add_to_group("map_objects")
	add_child(instance)
	return instance

func get_spawn_location():
	var grid_pos
	var attempts = 10
	for attempt in attempts:
		var rand_index = randi() % ground_cells.size()
		grid_pos = ground_cells[rand_index]
		if grid_pos not in dont_place_here:
			break

	return tile_to_world(grid_pos) + cell_size / 2

func between(val, start, end):
	if start <=val and val <end:
		return true
	return false
			
func tile_to_world(tile_pos: Vector2i) -> Vector2:
	return Vector2(tile_pos.x * cell_size.x, tile_pos.y * cell_size.y)

func getRandomTreeSprite():
	var treeSprites = [
		"res://Assets/Sprites//Objects/trees/tree1.png",
		"res://Assets/Sprites//Objects/trees/tree2.png",
		"res://Assets/Sprites//Objects/trees/tree3.png",
		"res://Assets/Sprites//Objects/trees/tree4.png",
		"res://Assets/Sprites//Objects/trees/tree5.png",
		"res://Assets/Sprites//Objects/trees/tree6.png",
		"res://Assets/Sprites//Objects/trees/tree7.png",
		"res://Assets/Sprites//Objects/trees/tree8.png",
	]
	var randomIndex = randi() % treeSprites.size()
	var newTexture = load(treeSprites[randomIndex])
	return newTexture
