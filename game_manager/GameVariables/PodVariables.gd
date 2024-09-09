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

func get_weapon_cost(gun_name: String):
	for i in range(0, weapons.size(), 2):
		if weapons[i] == gun_name:
			return weapons[i+1]
