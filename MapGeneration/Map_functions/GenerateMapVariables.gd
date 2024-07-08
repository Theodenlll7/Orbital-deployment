extends Node2D

@export var width = 200
@export var height = 200
@export var spawnArea_size = 20
@export var randomObjectChance = 0.01
@export var randomDungeon = 0.0001
var center_offset = Vector2(-width / 2, -height / 2)
const LAND_CAP = 0.2


#Variables for spawning
var max_chest_count = 50
var chests = []

#Information_Arrays
@export var dont_place_here = []

#Generation_Arrays
@export var ground_cells = []
@export var water_cells = []
@export var dirt_cells=[]
@export var path_cells = []
@export var Tree_cells = []

@export var map_Edge_cells = []
@export var random_Object_cells = []
@export var dungeon_cells = []

#Cell info
@export var cell_size = Vector2(16, 16)

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

func generate_cells():
	var center_x = width / 2
	var center_y = height / 2
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
							random_Object_cells.append(Vector2i(map_x, map_y))
						if between(temp, 0.2, 0.6):
							dont_place_here.append(Vector2i(map_x, map_y))
							Tree_cells.append(Vector2i(map_x, map_y))
						elif randf()< randomDungeon: 
							dungeon_cells.append(Vector2i(map_x, map_y))
					#elif between(alt, 0.2, 0.25):
						#shallow_water_cells.append(Vector2i(map_x, map_y))
					#elif between(alt, 0.25, 0.8):
						#if between(moist, 0, 0.4) and between(temp, 0.2, 0.6):
							#dirt_cells.append(Vector2i(map_x, map_y))

func spawn_chests():
	if len(chests) >=max_chest_count:
		return
	print("called spawn_chest, with ", chests.size(), "chests:")
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
		
