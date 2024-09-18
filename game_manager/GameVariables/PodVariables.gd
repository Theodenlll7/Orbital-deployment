extends Node

var weapons : Array[Weapon] = []
var explosives = []
var special_equipment = []

signal weapons_loaded

func _ready():
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
