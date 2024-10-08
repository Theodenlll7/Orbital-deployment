extends Node2D

class_name WaveManager

# Exported variables
@export var spawn_radius_min: int = 500  # Minimum distance from players for spawning
@export var spawn_radius_max: int = 600  # Maximum distance from players for spawning
@export var spawn_interval: float = 3.0  # Time between spawns

@export var enemy_spawn_pool: Array[PackedScene] = []

# Difficulty progression variables
@export var initial_enemies_to_spawn: int = 10  ## Initial number of enemies
@export var wave_enemy_increment: int = 5       ## Number of additional enemies each wave
@export var initial_mean: float = 0.0           ## Mean for normal distribution (index in the array)
@export var initial_std_dev: float = 0.5        ## Initial standard deviation for normal distribution

@onready var players = get_tree().get_nodes_in_group("players")

signal new_wave_started(wave: int)
signal end_of_wave(time_until_next_wave: float)
signal nr_of_enemies(nr: int)

var spawn_timer = spawn_interval  # Timer for controlling spawn intervals

var wave = 0

const in_between_wave_time = 10.0

var enemy_count = 0

var enemies_spawnd_this_wave : int = 0

var enemies_to_spawn: int = 0

var wave_finished := false

var in_between_wave_timer = Timer.new()

func start_next_wave():
	print("Start Wave")
	wave += 1
	enemies_to_spawn = initial_enemies_to_spawn + (wave - 1) * wave_enemy_increment
	new_wave_started.emit(wave)
	wave_finished = false
	process_wave()

	
func _enemy_death():
	enemy_count -= 1
	nr_of_enemies.emit(enemy_count)
	if enemy_count <= 0:
		in_between_wave_timer.start()
		end_of_wave.emit(in_between_wave_time)
		
		
func _ready() -> void:
	add_to_group("managers")
	add_to_group("wave_manager")
	add_child(in_between_wave_timer)
	in_between_wave_timer.wait_time = in_between_wave_time
	in_between_wave_timer.one_shot = true
	in_between_wave_timer.timeout.connect(start_next_wave)
	in_between_wave_timer.start()
	enemies_to_spawn = initial_enemies_to_spawn
	

func process_wave():
	for i in range(enemies_to_spawn):
		spawn_enemy()
	nr_of_enemies.emit(enemy_count)
	wave_finished = true

# Spawn an enemy at a random valid position around one of the players
func spawn_enemy():
	var spawn_position = get_random_valid_position_around_players()
	var enemy = pick_enemy_based_on_difficulty().instantiate()
	enemy.add_to_group("enemies")
	enemy.global_position = spawn_position

	add_child(enemy)
	var death = enemy.get_node("HandleEnemeyDeath") as HandleEnemeyDeath
	death.died.connect(_enemy_death)
	enemy_count += 1

# Function to gradually shift the distribution of enemy difficulty using randfn
func pick_enemy_based_on_difficulty() -> PackedScene:
	var pool_size = enemy_spawn_pool.size()
	var wave_progression = min(wave / 10.0, 1.0)  # Gradual progression to harder enemies (capped at 1.0)
	
	# Shift the mean toward the harder enemies as waves progress
	var mean = initial_mean + wave_progression * (pool_size - 1)
	var std_dev = initial_std_dev + wave_progression * 2.0  # Increase variance as waves go on

	# Generate an index using randfn
	var index = int(clamp(randfn(mean, std_dev), 0, pool_size - 1))
	return enemy_spawn_pool[index]


# Find a random valid tile position that is at a valid distance from all players
func get_random_valid_position_around_players():
	var attempts := 0
	while attempts < 100:
		var chosen_player = players.pick_random()
		var player_pos = chosen_player.global_position

		# Generate a random point within the allowed radius around the chosen player
		var angle = randf() * TAU  # Random angle in radians (0 to 2π)
		var distance = randf_range(spawn_radius_min, spawn_radius_max)
		var offset = Vector2(cos(angle), sin(angle)) * distance
		var potential_position = player_pos + offset

		potential_position = get_point_on_map(potential_position, 2)
		if is_valid_distance_from_all_players(potential_position):
			return potential_position


# Ensure the position is at least the minimum distance from all players
func is_valid_distance_from_all_players(pos):
	for player in players:
		var player_pos = player.global_position
		var distance_to_player = player_pos.distance_to(pos)
		if distance_to_player < spawn_radius_min:
			return false  # Too close to a player
	return true


func get_point_on_map(target_point: Vector2, min_dist_from_edge: float) -> Vector2:
	var map := get_world_2d().navigation_map
	var closest_point := NavigationServer2D.map_get_closest_point(map, target_point)
	var delta := closest_point - target_point
	var is_on_map = delta.is_zero_approx()  # Answer to original question!
	if not is_on_map and min_dist_from_edge > 0:
		# Wasn't on the map, so push in from edge.
		delta = delta.normalized()
		closest_point += delta * min_dist_from_edge
	return closest_point
