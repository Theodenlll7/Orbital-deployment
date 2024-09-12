extends Node

var weapons = []
var explosives = []
var special_equipment = []

func _ready():
	var pistol1 = Weapon.new("Pistol 1", 100, Weapon.AttackMode.AUTOMATIC, 0.1)
	var pistol2 = Weapon.new("Pistol 2", 200, Weapon.AttackMode.AUTOMATIC, 0.1)
	var pistol3 = Weapon.new("Pistol 3", 300, Weapon.AttackMode.AUTOMATIC, 0.1)
	
	var shotgun1 = Weapon.new("Shotgun 1", 100, Weapon.AttackMode.SINGLE, 0.5)
	var shotgun2 = Weapon.new("Shotgun 2", 200, Weapon.AttackMode.SINGLE, 0.5)
	
	var assault_rifle1 = Weapon.new("Assault Rifle 1", 100, Weapon.AttackMode.AUTOMATIC, 0.2)
	var assault_rifle2 = Weapon.new("Assault Rifle 2", 200, Weapon.AttackMode.AUTOMATIC, 0.2)
	var assault_rifle3 = Weapon.new("Assault Rifle 3", 300, Weapon.AttackMode.AUTOMATIC, 0.2)
	var assault_rifle4 = Weapon.new("Assault Rifle 4", 400, Weapon.AttackMode.AUTOMATIC, 0.2)
	
	var machinegun1 = Weapon.new("Machinegun 1", 100, Weapon.AttackMode.AUTOMATIC, 0.1)
	var machinegun2 = Weapon.new("Machinegun 2", 200, Weapon.AttackMode.AUTOMATIC, 0.1)

	var laser_gun1 = Weapon.new("Laser Gun 1", 100, Weapon.AttackMode.SINGLE, 0.3)
	var laser_gun2 = Weapon.new("Laser Gun 2", 200, Weapon.AttackMode.SINGLE, 0.3)
	
	var sniper1 = Weapon.new("Sniper 1", 100, Weapon.AttackMode.SINGLE, 1.0)
	var sniper2 = Weapon.new("Sniper 2", 200, Weapon.AttackMode.SINGLE, 1.0)
	
	weapons.append(pistol1)
	weapons.append(pistol2)
	weapons.append(pistol3)
	weapons.append(shotgun1)
	weapons.append(shotgun2)
	weapons.append(assault_rifle1)
	weapons.append(assault_rifle2)
	weapons.append(assault_rifle3)
	weapons.append(assault_rifle4)
	weapons.append(machinegun1)
	weapons.append(machinegun2)
	weapons.append(laser_gun1)
	weapons.append(laser_gun2)
	weapons.append(sniper1)
	weapons.append(sniper2)
	
	
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
			
