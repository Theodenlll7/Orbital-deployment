extends Node2D

var alien = preload("res://enemies/mobs/alien.tscn")
var ranger = preload("res://enemies/mobs/ranger.tscn")
var ground_positions = GenerateMapVariables.ground_cells
var day_count = 0
var chance_of_boss = 0.5

var enemies_to_spawn = [] 
var current_spawn_index = 0 

@export var spawn_timer: Timer 
func _ready() -> void:
	spawn_timer = Timer.new()  
	spawn_timer.wait_time = 5.0  #
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)  
	add_child(spawn_timer)  

func _on_spawn_timer_timeout():
	if current_spawn_index < enemies_to_spawn.size():
		var enemy_type = alien  
		var enemy_instance = enemy_type.instantiate()
		set_enemy_stats(enemy_instance, day_count)  
		enemy_instance.position = enemies_to_spawn[current_spawn_index]  
		add_child(enemy_instance)  
		current_spawn_index += 1  
	else:
		spawn_timer.stop()  
		
func new_day(day: int):
	day_count = day  
	current_spawn_index = 0  

	var enemy_count = day * 2  
	var enemies = [alien, ranger]

	var positions_copy = ground_positions.duplicate()  
	positions_copy.shuffle()  

	enemies_to_spawn = positions_copy.slice(0, enemy_count)  
	
	spawn_timer.start()  
	
func set_enemy_stats(enemy_instance, day):
	if randf() < chance_of_boss:
		var base_health = 100
		var base_damage = 2
		var base_speed = 40
		#Specific for Aliens..
		enemy_instance.speed = base_speed*day
		var attacks = enemy_instance.get_node("AttackRange")
		attacks.damage = base_damage*day
		var health = enemy_instance.get_node("HealthComponent")
		health.max_health = base_health*day
		health.current_health = base_health*day
	else:
		set_up_boss(enemy_instance, day)
	
func set_up_boss(enemy_instance, day):
	var base_health = 1000
	var base_damage = 40
	var base_speed = 5
		#Specific for Aliens..
	enemy_instance.speed = base_speed*day
	var attacks = enemy_instance.get_node("AttackRange")
	attacks.damage = base_damage*day
	var health = enemy_instance.get_node("HealthComponent")
	health.max_health = base_health*day
	health.current_health = base_health*day
	
	enemy_instance.scale = Vector2(4,4)
	
func _process(delta: float) -> void:
	pass
