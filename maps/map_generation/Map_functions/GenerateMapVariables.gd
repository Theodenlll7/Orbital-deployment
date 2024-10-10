extends Node2D

@export var width = 75
@export var height = 75
@export var spawnArea_size = 5
@export var randomObjectChance = 0.8
@export var randomTreeChance = 0.01

@export var current_tree_chance = 0.6

@export var treeScale = 1.2
@export var treeRespawnTime = 25

var center_offset = Vector2(-width / 2.0, -height / 2.0)
const LAND_CAP = 0.4

#Variables for spawning
var max_chest_count = 10
var chests = []

#Information_Arrays
var dont_place_here = []
var water_is_here = []

#Generation_Arrays
var ground_cells = []
var water_cells = []
var entire_map_cells = []
var dirt_cells = []
var path_cells = []
var ground2_cells = []

var map_Edge_cells = []
var random_Object_cells = []
var random_WaterObject_cells = []
var random_tree_cells = []

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
var chest = preload("res://maps/objects/chest/chest.tscn")
var weapon_pod = preload("res://maps/objects/pods/weapon_pod.tscn")
var orbital_strike_pod = preload("res://maps/objects/pods/orbital_strike_pod.tscn")
var explosives_pod = preload("res://maps/objects/pods/explosives_pod.tscn")

var pods = [weapon_pod, explosives_pod, orbital_strike_pod]


func _ready():
	randomize()
	altitude.seed = randi()
	noise.seed = randi()
	altitude.frequency = 0.1
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
			entire_map_cells.append(Vector2i(map_x, map_y))

			if x == 0 or x == width - 1 or y == 0 or y == height - 1:
				map_Edge_cells.append(Vector2i(map_x, map_y))
			else:
				var distance_to_center = Vector2(map_x, map_y).length()
				if distance_to_center <= spawnArea_size:
					ground_cells.append(Vector2i(map_x, map_y))
				else:
					if alt < LAND_CAP:
						ground_cells.append(Vector2i(map_x, map_y))
						if randf() > randomObjectChance:
							if (
								#checkToCloseToMapEdge(Vector2(map_x, map_y), 5)
								isPosCloseToObjects(Vector2(map_x, map_y), random_Object_cells)
								or isPosCloseToObjects(Vector2(map_x, map_y), water_is_here)
								or between(temp, 0.2, 0.6)
							):
								pass
							else:
								random_Object_cells.append(Vector2i(map_x, map_y))
						if (
							randf() < randomTreeChance
				
						):
							random_tree_cells.append(Vector2i(map_x, map_y))
						if between(temp, 0.2, 0.6):
							dont_place_here.append(Vector2i(map_x, map_y))
							ground2_cells.append(Vector2i(map_x, map_y))
						elif between(alt, 0.1, 0.9):
							if between(moist, 0, 0.4) and between(temp, 0.2, 0.6):
								dirt_cells.append(Vector2i(map_x, map_y))

						elif randf() < randomObjectChance:
							if (
								checkToCloseToMapEdge(Vector2(map_x, map_y), 10)
								or isPosCloseToObjects(
									Vector2(map_x, map_y), random_WaterObject_cells
								)
								or isPosCloseToObjects(Vector2(map_x, map_y), ground_cells)
							):
								pass
							else:
								random_WaterObject_cells.append(Vector2i(map_x, map_y))
					else:
						water_is_here.append(Vector2i(map_x, map_y))
						water_cells.append(Vector2i(map_x, map_y))

					#elif between(alt, 0.2, 0.25):
					#shallow_water_cells.append(Vector2i(map_x, map_y))


func isPosCloseToObjects(pos, list):
	for other_pos in list:
		if Vector2(pos).distance_to(Vector2(other_pos)) < 3:
			return true
	return false


func checkToCloseToMapEdge(pos, maxDistance):
	var edge_min = -width / 2.0
	var edge_max = width / 2.0

	var y_vectorMax = Vector2(0, edge_max)
	var y_vectorMin = Vector2(0, edge_min)

	var x_vectorMax = Vector2(edge_max, 0)
	var x_vectorMin = Vector2(edge_min, 0)

	var tempXVec = Vector2(pos.x, 0)
	var tempYVec = Vector2(0, pos.y)

	if (
		tempXVec.distance_to(x_vectorMax) < maxDistance
		or tempXVec.distance_to(x_vectorMin) < maxDistance
	):
		return true
	if (
		tempYVec.distance_to(y_vectorMax) < maxDistance
		or tempXVec.distance_to(y_vectorMin) < maxDistance
	):
		return true
	return false

func get_valid_spawn_location(): 
	var attempts = 0
	var spawn_position
	while attempts < 100:
		var random_index = randi() % ground_cells.size()
		spawn_position = ground_cells[random_index]
		if !isPosCloseToObjects(spawn_position, water_is_here):
			return tile_to_world(spawn_position)
	
	return spawn_position
	
func Get_pod_locations():
	var podCount = 0
	var attempts = 0

	while podCount < numberOfPods and attempts < 1000:
		attempts += 1
		var rand_index = randi() % ground_cells.size()
		var pod_location = ground_cells[rand_index]
		var can_place = true

		for existing_pods in pod_positions:
			if Vector2(pod_location).distance_to(Vector2(existing_pods)) < podDistanceBetween:
				can_place = false
				break
		for pos in dont_place_here:
			if pod_location == pos:
				can_place = false
				break
		if can_place:
			pod_positions.append(pod_location)
			podCount += 1


func spawn_chests():
	if len(chests) >= max_chest_count:
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
			if Vector2(chest_location).distance_to(Vector2(existing_chest)) < chest_distance:
				can_place = false
				break
		for pos in dont_place_here:
			if chest_location == pos:
				can_place = false
				break
		for pos in pod_positions:
			if Vector2(chest_location).distance_to(Vector2(pos)) < chest_distance:
				can_place = false
				break
		if can_place:
			var chest_instance = chest.instantiate()
			chest_instance.position = tile_to_world(chest_location) + cell_size / 2
			chest_instance.z_index = 1
			add_child(chest_instance)
			chests.append(chest_location)
			chest_instance.set_meta("chest_location", chest_location)
			#chest_instance.connect("chest_picked_up", Callable(self, "_on_chest_picked_up"))
			chest_count += 1
	print("after spawn ", chests.size(), "chests:")


func between(val, start, end):
	if start <= val and val < end:
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


func spawnPod(type):
	var pod_instance = pods[type].instantiate()
	pod_instance.position = tile_to_world(pod_positions[type])
	pod_instance.z_index = 1
	var parent_node = get_parent()
	parent_node.add_child(pod_instance)
