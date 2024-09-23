extends Node

var weapons: Array[Weapon] = []
var explosives = []
var special_equipment = []


func _ready():
	# Create SpecialEquipment instances and add them to the special_equipment list
	var orbital_strike = SpecialEquipment.new(
		"Orbital Strike", 200, "Devastating orbital bombardment", "Orbital Strike"
	)
	var orbital_precision_strike = SpecialEquipment.new(
		"Orbital Precision Strike",
		250,
		"Precision orbital strike with targeting",
		"Precision Strike"
	)
	var ai_bots = SpecialEquipment.new("AI Bots", 275, "Deploys AI-controlled bots", "AI Bots")

	special_equipment.append(orbital_strike)
	special_equipment.append(orbital_precision_strike)
	special_equipment.append(ai_bots)


func get_cost(id: String, type_of_array: Array):
	for i in range(0, type_of_array.size(), 2):
		if type_of_array[i] == id:
			return type_of_array[i + 1]
