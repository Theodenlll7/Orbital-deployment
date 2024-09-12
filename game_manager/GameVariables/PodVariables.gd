extends Node

var weapons = [
	"Pistol 1", 100, 
	"Pistol 2", 200,
	"Pistol 3", 300,
	
	"Shotgun 1", 100,
	"Shotgun 2", 200,
	
	"Assault Rifle 1", 100,
	"Assault Rifle 2", 200,
	"Assault Rifle 3", 300,
	"Assault Rifle 4", 400,
	
	"Machinegun 1", 100,
	"Machinegun 2", 200,

	"Laser Gun 1", 100,
	"Laser Gun 2", 200,	

	"Sniper 1", 100,
	"Sniper 2", 200,	
]

var explosives = [
	"Grenades", 5,
	"Stun Grenades", 10,
	"RPG", 150,
	"Machine Gun Turret", 80,
	"Self Revive", 200,
	"Armor", 50,
]

var special_equipment = [
	"Orbital Strike", 200,
	"Orbital Precision Strike", 250,
	"AI Bots", 275,
	
]
func get_cost(name: String, type_of_array: Array):
	for i in range(0, type_of_array.size(), 2):
		if type_of_array[i] == name:
			return type_of_array[i+1]
			
