extends Node

var healt_scaler: float = 1.0
var bullet_damage_scaler: float = 1.0
var health_regeneration_scaler: float = 0.0
var start_money_increase: float = 0.0

var json_url = "res://ui/main_menu/skill_tree_assets/data/skills.json"
var skill_layout: Dictionary = {}

func get_skill_layout() -> Dictionary:
	if skill_layout == {}:
		load_skill_layout()
	return skill_layout

func load_skill_layout() -> void:
	var file = FileAccess.open(json_url, FileAccess.READ)
	if file:
		var json_object = JSON.new()
		json_object.parse(file.get_as_text())
		skill_layout = json_object.get_data()
	else:
		print("Failed to open json file!")

func set_new_healt_scaler(new_scale: float) -> void:
	if(new_scale < healt_scaler || new_scale < 0.0):
		print("Health alrady have a greater scale")
		pass
	healt_scaler = new_scale
	print("Health scaled with ", healt_scaler)

func remove_from_healt_scaler(scale: float) -> void:
	healt_scaler = max(healt_scaler - scale, 1.0)
	print("Health scaled down to ", healt_scaler)

func set_new_bullet_damage_scaler(new_scale: float) -> void:
	if(new_scale < bullet_damage_scaler || new_scale < 0.0):
		print("Bullet damage alrady have a greater scale")
		pass
	bullet_damage_scaler = new_scale
	print("Bullet damage scaled with ", bullet_damage_scaler)

func remove_from_bullet_damage_scaler(scale: float) -> void:
	bullet_damage_scaler = max(bullet_damage_scaler - scale, 1.0)
	print("Bullet damage scaled down to ", bullet_damage_scaler)

func set_new_health_regeneration_scaler(new_scale: float) -> void:
	if(new_scale < health_regeneration_scaler || new_scale < 1.0):
		print("Health regeneration scaler alrady have a greater scale")
		pass
	health_regeneration_scaler = new_scale
	print("Health regeneratione scaled with ", health_regeneration_scaler, " / s")

func remove_from_health_regeneration_scaler(scale: float) -> void:
	health_regeneration_scaler = max(health_regeneration_scaler - scale, 0.0)
	print("Health regeneratione scaled down to ", health_regeneration_scaler, " / s")

func set_new_money_increase(new_start_money_increase: float) -> void:
	if(new_start_money_increase < start_money_increase || new_start_money_increase < 0.0):
		print("Start credits at start alrady have a greater value")
		pass
	start_money_increase = new_start_money_increase
	print("Start credits set to ", start_money_increase, "$")

func remove_from_money_increase(money_decresse: float) -> void:
	start_money_increase = max(health_regeneration_scaler - money_decresse, 0.0)
	print("Start credits set down to ", start_money_increase, "$")
