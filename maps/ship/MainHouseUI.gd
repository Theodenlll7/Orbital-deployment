extends Control

func _ready():
	updateButtonLabels()

func _process(delta):
	pass

func _on_upgrade_turret_button_pressed():
	GameVariables.upgradeFromPod("towerUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()

func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.getPlayerMoney()) + "$"
	
	var weapon_path_upgrades = $Weapon_paths
	for i in range(weapon_path_upgrades.get_child_count()):
		var child = weapon_path_upgrades.get_child(i)
		for j in range(child.get_child_count()):
			child.get_child(j).get_child(0).text = "23"
			child.get_child(j).get_child(0).text = "23"


	
func _on_pistols_button_pressed(extra_arg_0: int) -> void:
	var weaponsUI = $weapons_UI
	weaponsUI.hide()
	var newUI = getWeaponUI(extra_arg_0)
	showCorrectWeaponUI(newUI)

func getWeaponUI(value):
	var weapon_node_tree = $Weapon_paths
	weapon_node_tree.show()
	return weapon_node_tree.get_child(value-1)

func showCorrectWeaponUI(not_to_hide):
	var weapon_node_tree = $Weapon_paths
	for i in range(weapon_node_tree.get_child_count()):
		var child = weapon_node_tree.get_child(i)
		child.hide()  
	not_to_hide.show()
	$Weapon_paths/back_button.show()
	$Weapon_paths/back_button/Label.show()


func _on_back_button_pressed() -> void:
	var weapon_node_tree = $Weapon_paths
	weapon_node_tree.hide()
	var weaponsUI = $weapons_UI
	weaponsUI.show()

func _on_pistol_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Pistol", extra_arg_0)

func _on_shotgun_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Shotgun", extra_arg_0)

func _on_assault_rifle_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Assault_Rifle", extra_arg_0)

func _on_machine_gun_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Machine_Gun", extra_arg_0)

func _on_laser_gun_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Laser_Gun", extra_arg_0)

func _on_sniper_upg_pressed(extra_arg_0: int) -> void:
	handleBuy("Sniper_Gun", extra_arg_0)

func handleBuy(type, upg_tier):
	if GameVariables.getPlayerMoney() >= upg_tier*100:
		print("Player just Bought a ", type)
	else:
		print("Not enough money to buy that")
