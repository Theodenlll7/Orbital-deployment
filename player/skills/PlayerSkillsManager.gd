extends Node

var healt_scaler: float = 1.0
var bullet_damage_scaler: float = 1.0
var health_regeneration_scaler: float = 0.0

func get_healt_scaler() -> float:
	return healt_scaler

func get_bullet_damage_scaler() -> float:
	return bullet_damage_scaler
	
func get_health_regeneration_scaler() -> float:
	return health_regeneration_scaler

func set_new_healt_scaler(new_scale: float) -> void:
	if(new_scale < healt_scaler || new_scale < 0.0):
		print("Health alrady have a greater scale")
		pass
	healt_scaler = new_scale
	print("Health scaled with ", healt_scaler)


func set_new_bullet_damage_scaler(new_scale: float) -> void:
	if(new_scale < bullet_damage_scaler || new_scale < 0.0):
		print("Bullet damage alrady have a greater scale")
		pass
	bullet_damage_scaler = new_scale
	print("Bullet damage scaled with ", healt_scaler)

func set_new_health_regeneration_scaler(new_scale: float) -> void:
	if(new_scale < health_regeneration_scaler || new_scale < 1.0):
		print("Health regeneration scaler alrady have a greater scale")
		pass
	health_regeneration_scaler = new_scale
	print("Health regeneratione scaled with ", healt_scaler, " / s")
