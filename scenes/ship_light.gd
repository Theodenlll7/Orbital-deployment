extends Node2D

@onready var ship_point_light_2d: PointLight2D = $ShipPointLight2D
var time_elapsed: float = 0.0
var flash_interval: float = 0.18
var max_energy: float = 1.0
var min_energy: float = 0.0  # Set to 0.0 for flickering effect
var fade_time: float = 0.2
var fade_elapsed: float = 0.0

func _process(delta: float) -> void:    
	time_elapsed += delta
	fade_elapsed += delta
	
	if fade_elapsed >= fade_time:
		if time_elapsed >= flash_interval:
			var random_value = randf_range(0.0, 10.0)

			var target_color = ship_point_light_2d.color
			
			if random_value > 8.0:
				target_color.a = 1.0
				ship_point_light_2d.color = target_color
			else:
				target_color.a = 0.6
				var tween = get_tree().create_tween()
				tween.tween_property(ship_point_light_2d, "color", target_color, fade_time)
			fade_elapsed = 0.0
		time_elapsed = 0.0
