extends TileMap

# Initialize noise generators for different map features
# Values between -1 and 1
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

# Dimensions of each generated chunk
var width = 120
var height = 120

# Reference to the player character
@onready var player = get_parent().get_node("MainCharacter2D")

# List to keep track of loaded chunks
var loaded_chunks = []

# Tile variables
var tile_grass = Vector2(1, 9) # Replace with actual coordinates of the grass tile in your tilemap
var tile_water = Vector2(4, 9) # Replace with actual coordinates of the water tile in your tilemap
var tile_beach = Vector2(3, 9) # Replace with actual coordinates of the beach tile in your tilemap

func _ready():
	# Set random seeds for noise variation
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()

	# Adjust this value to change the 'smoothness' of the map; lower values mean more smooth noise
	altitude.frequency = 0.01

func _process(delta):
	# Convert the player's position to tile coordinates
	var player_tile_pos = local_to_map(player.position)

	# Generate the chunk at the player's position
	generate_chunk(player_tile_pos)

	# Unload chunks that are too far away.
	# Note: Not needed for smaller projects but if you are loading a bigger tilemap it's good practice
	unload_distant_chunks(player_tile_pos)

func generate_chunk(pos):
	for x in range(width):
		for y in range(height):
			# Generate noise values for moisture, temperature, and altitude
			var moist = moisture.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10 # Values between -10 and 10
			var temp = temperature.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10
			var alt = altitude.get_noise_2d(pos.x - (width/2) + x, pos.y - (height/2) + y) * 10

			# Set the cell based on altitude; adjust for different tile types
			# Need to evenly distribute -10 -> 10 to 0 -> 4....  This can be done by first adding 10
			# Gets values from 0 -> 20... Then we will multiply by 3/20 in order to remap it to 0 -> 3
			# vvv

			if alt < 0: # Arbitrary sea level value (choosing 0 will mean roughly 1/2 the world is ocean)
				set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 1, tile_water) # Water tile
			else: 
				if alt < 0.5: # Beach tiles for altitudes between 0 and 0.5
					set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 1, tile_beach)
				else:
					set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), 1, tile_grass) # Grass tile

			if Vector2i(pos.x, pos.y) not in loaded_chunks:
				loaded_chunks.append(Vector2i(pos.x, pos.y))

# Function to unload chunks that are too far away
func unload_distant_chunks(player_pos):
	# Set the distance threshold to at least 2 times the width to limit visual glitches
	# Higher values unload chunks further away
	var unload_distance_threshold = (width * 2) + 1

	for chunk in loaded_chunks:
		var distance_to_player = get_dist(chunk, player_pos)

		if distance_to_player > unload_distance_threshold:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)

# Function to clear a chunk
func clear_chunk(pos):
	for x in range(width):
		for y in range(height):
			set_cell(0, Vector2i(pos.x - (width/2) + x, pos.y - (height/2) + y), -1, Vector2(-1, -1), -1)

# Function to calculate distance between two points
func get_dist(p1, p2):
	var resultant = p1 - p2
	return sqrt(resultant.x ** 2 + resultant.y ** 2)
