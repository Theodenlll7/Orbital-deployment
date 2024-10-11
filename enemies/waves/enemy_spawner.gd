extends Node2D

class_name WaveManager

# Exported variables
@export_category("Mob Spawning")
@export var spawn_radius_min: int = 500  # Minimum distance from players for spawning
@export var spawn_radius_max: int = 600  # Maximum distance from players for spawning
@export var spawn_interval: float = 3.0  # Time between spawns

# Difficulty progression variables
@export_category("Enemie count progression")
@export_range(1, 100, 1, "or_greater") var growth_rate: float = 2.0  # Controls how fast the number of enemies increases
@export_range(1, 100, 1, "or_greater") var starting_enemy_count: int = 5  # Minimum number of enemies at the start
@export_range(1, 100, 1, "or_greater") var max_enemy_count: int = 50  # Maximum number of enemies as difficulty progresses

# The shift value is hidden and not exposed to the user
const curve_shift: float = 1.0  # Internal shift to avoid log(0)

@export_category("How enemies are picked in waves")
@export var enemy_spawn_pool: Array[PackedScene] = []

@export_range(0, 1) var initial_mean: float = 0.0  ## Mean for normal distribution (index in the array)
@export_range(0, 1) var initial_std_dev: float = 0.5  ## Initial standard deviation for normal distribution

@onready var players = get_tree().get_nodes_in_group("players")

@export var custom_waves: Array[CustomWave] = []:
	set(value):
		custom_waves = value
		custom_waves.sort_custom(func(a, b): return a.wave_number < b.wave_number)

signal new_wave_started(wave: int)
signal end_of_wave(time_until_next_wave: float)
signal nr_of_enemies(nr: int)

var spawn_timer = spawn_interval  # Timer for controlling spawn intervals

var wave = 0

const in_between_wave_time = 10.0

var enemy_count = 0

var enemies_spawnd_this_wave: int = 0

var enemies_to_spawn: int = 0

var wave_finished := false

var in_between_wave_timer = Timer.new()

var next_custom_wave: int
var next_custom_wave_index: int = 0


func start_next_wave():
	print("Start Wave")
	wave += 1
	enemies_to_spawn = int(
		clamp(
			growth_rate * log(wave + curve_shift) + starting_enemy_count,
			starting_enemy_count,
			max_enemy_count
		)
	)
	new_wave_started.emit(wave)
	wave_finished = false
	process_wave()
	update_weapon_pods(wave)

func _enemy_death():
	enemy_count -= 1
	nr_of_enemies.emit(enemy_count)
	if enemy_count <= 0:
		in_between_wave_timer.start()
		end_of_wave.emit(in_between_wave_time)

func update_weapon_pods(_wave):
	var parent = get_parent()
	for child in parent.get_children():
		if child.name == "WeaponPod":
			var canvas_layer = child.get_node("CanvasLayer")
			var store_ui = canvas_layer.get_node("StoreUI")
			store_ui.update_weapons(_wave)
			
func _ready() -> void:
	add_to_group("managers")
	add_to_group("wave_manager")
	add_child(in_between_wave_timer)
	in_between_wave_timer.wait_time = in_between_wave_time
	in_between_wave_timer.one_shot = true
	in_between_wave_timer.timeout.connect(start_next_wave)
	in_between_wave_timer.start()
	enemies_to_spawn = starting_enemy_count

	if !custom_waves.is_empty():
		next_custom_wave = custom_waves[next_custom_wave_index].wave_number


func process_wave():
	if wave == next_custom_wave:
		_spawn_custom_wave(custom_waves[next_custom_wave_index])
		next_custom_wave_index += 1 if next_custom_wave_index != custom_waves.size() - 1 else 0
		next_custom_wave = custom_waves[next_custom_wave_index].wave_number
	else:
		for i in range(enemies_to_spawn):
			var enemy = pick_enemy_based_on_difficulty()
			spawn_enemy(enemy)

	nr_of_enemies.emit(enemy_count)
	wave_finished = true


func _spawn_custom_wave(custom_wave: CustomWave) -> void:
	for enemy in custom_wave.enemies:
		spawn_enemy(enemy.instantiate())
	pass


# Spawn an enemy at a random valid position around one of the players
func spawn_enemy(enemy: Node):
	var spawn_position
	if has_node("../MapGeneration"):
		spawn_position = GenerateMapVariables.get_valid_spawn_location()
	else:
		spawn_position = get_random_valid_position_around_players()

	enemy.add_to_group("enemies")
	enemy.global_position = spawn_position

	add_child(enemy)
	var death = enemy.get_node("HandleEnemeyDeath") as HandleEnemeyDeath
	death.died.connect(_enemy_death)
	enemy_count += 1


# Function to gradually shift the distribution of enemy difficulty using randfn
func pick_enemy_based_on_difficulty() -> Node:
	var pool_size = enemy_spawn_pool.size()
	var wave_progression = min(wave / 10.0, 1.0)  # Gradual progression to harder enemies (capped at 1.0)

	# Shift the mean toward the harder enemies as waves progress
	var mean = initial_mean + wave_progression * (pool_size - 1)
	var std_dev = initial_std_dev  #+ wave_progression * 2.0  # Increase variance as waves go on

	# Generate an index using randfn
	var index = int(clamp(randfn(mean, std_dev), 0, pool_size - 1))
	return enemy_spawn_pool[index].instantiate()


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
