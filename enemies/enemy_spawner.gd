extends Node2D

class_name enemy_spawner

# Exported variables
@export var enemy_scene: PackedScene  # The enemy scene to instantiate
@export var spawn_radius_min: int = 200  # Minimum distance from players for spawning
@export var spawn_radius_max: int = 500  # Maximum distance from players for spawning
@export var max_enemies: int = 20  # Max number of enemies at a time
@export var spawn_interval: float = 5.0  # Time between spawns

@onready var players = get_tree().get_nodes_in_group("players")

var spawn_timer = spawn_interval  # Timer for controlling spawn intervals


# Main game loop
func _process(delta):
	if spawn_timer < 0:
		spawn_timer = spawn_interval
		spawn_enemy()
	spawn_timer -= delta


# Spawn an enemy at a random valid position around one of the players
func spawn_enemy():
	var spawn_postion = get_random_valid_position_around_players()
	var enemy = enemy_scene.instantiate()
	enemy.global_position = spawn_postion
	add_child(enemy)


# Find a random valid tile position that is at a valid distance from all players
func get_random_valid_position_around_players():
	var attempts := 0
	while attempts < 100:
		var chosen_player = players[randi() % players.size()]
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
