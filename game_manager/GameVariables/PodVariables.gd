extends Node

var weapons : Array[Weapon] = []
var explosives = []
var special_equipment = []

@export var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"

func _ready():
	var weapon_data = load_all_resources(weapons_dir)
	for data in weapon_data:
		match data:
			WeaponData:
				weapons.append(Weapon.new(data))
			ProjectileWeaponData:
				weapons.append(ProjectileWeapon2D.new(data))
	
	
	var grenade = Explosive.new("Grenades", 5, 50.0, "Standard Grenade")
	var stun_grenade = Explosive.new("Stun Grenades", 10, 25.0, "Stun Grenade")
	var rpg = Explosive.new("RPG", 150, 500.0, "Rocket Propelled Grenade")
	var machine_gun_turret = Explosive.new("Machine Gun Turret", 80, 200.0, "Turret")
	var self_revive = Explosive.new("Self Revive", 200, 0.0, "Revives the user")
	var armor = Explosive.new("Armor", 50, 0.0, "Protective Armor")

	explosives.append(grenade)
	explosives.append(stun_grenade)
	explosives.append(rpg)
	explosives.append(machine_gun_turret)
	explosives.append(self_revive)
	explosives.append(armor)
	
	# Create SpecialEquipment instances and add them to the special_equipment list
	var orbital_strike = SpecialEquipment.new("Orbital Strike", 200, "Devastating orbital bombardment", "Orbital Strike")
	var orbital_precision_strike = SpecialEquipment.new("Orbital Precision Strike", 250, "Precision orbital strike with targeting", "Precision Strike")
	var ai_bots = SpecialEquipment.new("AI Bots", 275, "Deploys AI-controlled bots", "AI Bots")

	special_equipment.append(orbital_strike)
	special_equipment.append(orbital_precision_strike)
	special_equipment.append(ai_bots)
	
func get_cost(name: String, type_of_array: Array):
	for i in range(0, type_of_array.size(), 2):
		if type_of_array[i] == name:
			return type_of_array[i+1]

func load_all_resources(folder_path: String) -> Array:
	var dir = DirAccess.open(folder_path)
	var resources = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				# Skip directories for now, or handle them recursively if needed
				pass
			elif file_name.ends_with(".tres"):
				var file_path = folder_path + file_name
				var resource = ResourceLoader.load(file_path)
				if resource:
					resources.append(resource)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Failed to open folder: " + folder_path)

	return resources
