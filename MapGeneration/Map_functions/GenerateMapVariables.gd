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


#Cell info
var cell_size = Vector2(16, 16)

# Noise
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()
var noise = FastNoiseLite.new()

#Objects
var chest= preload("res://Interaction/Prefabs/chest.tscn")


func _ready():
	randomize()
	altitude.seed = randi()
	noise.seed = randi()
	altitude.frequency = 0.01
	generate_cells()
	Get_pod_locations()

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

func Get_pod_locations():
	var podCount = 0
	var attempts = 0
	
	while podCount < numberOfPods and attempts < 1000:
		attempts +=1
		var rand_index = randi() % ground_cells.size()
		var pod_location = ground_cells[rand_index]
		var can_place = true
		
		for existing_pods in pod_positions:
			if Vector2(pod_location).distance_to(Vector2(existing_pods))<podDistanceBetween:
				can_place = false
				break
		for pos in dont_place_here:
			if pod_location == pos:
				can_place = false
				break
		if can_place:
			pod_positions.append(pod_location)
			podCount+=1
		
		print(pod_positions)
			
	print("after spawn ", chests.size(), "chests:")
func spawn_chests():
	if len(chests) >=max_chest_count:
		return

	var chest_distance = 5
	var chest_count = chests.size()
	var attempts = 0


	while chest_count < max_chest_count and attempts < 1000:
		attempts += 1
		var rand_index = randi() % ground_cells.size()
		var chest_location = ground_cells[rand_index]

		var can_place = true
		for existing_chest in chests:
			if Vector2(chest_location).distance_to(Vector2(existing_chest))<chest_distance:
				can_place = false
				break
		for pos in dont_place_here:
			if chest_location == pos:
				can_place = false
				break
		if can_place:
			var chest_instance = chest.instantiate()
			chest_instance.position = tile_to_world(chest_location) + cell_size / 2
			chest_instance.z_index = 1
			add_child(chest_instance)
			chests.append(chest_location)
			chest_instance.set_meta("chest_location", chest_location)
			chest_instance.connect("chest_picked_up", Callable(self, "_on_chest_picked_up"))
			chest_count +=1
	print("after spawn ", chests.size(), "chests:")


func between(val, start, end):
	if start <=val and val <end:
		return true
	return false

func _on_chest_picked_up(chest_instance):
	var chest_location = chest_instance.get_meta("chest_location")
	for i in range(chests.size()):
		if chests[i] == chest_location:
			chests.remove_at(i)
			break
			
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
			
