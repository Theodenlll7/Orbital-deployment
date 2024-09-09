extends Control

func _ready():
	updateButtonLabels()
	setLabelsAndCost()

func _process(delta):
	pass

func _on_upgrade_turret_button_pressed():
	GameVariables.upgradeFromPod("towerUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()
	
func setLabelsAndCost():
	var weapons = PodVariables.weapons
	var weapon_path_upgrades = $Weapon_paths
	var counter = 0
	for i in range(weapon_path_upgrades.get_child_count()):
		var child = weapon_path_upgrades.get_child(i)
		if child.name!="back_button":
			for j in range(child.get_child_count()):
				var button_node = child.get_child(j)
				var label_node = button_node.get_node("Label")
				var cost_node = button_node.get_node("Cost")
				label_node.text = str(weapons[counter])
				cost_node.text = str(weapons[counter+1])
				counter+=2
				
func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.getPlayerMoney()) + "$"

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

func _on_weaponPod_upg_pressed(extra_arg_0: int, type: String):
	var tier= extra_arg_0
	handleBuy(type, tier)
	
func handleBuy(type, upg_tier):
	var cost = PodVariables.get_weapon_cost(type)
	if GameVariables.getPlayerMoney() >=cost:
		print("Player just Bought a ", type, " Tier: ", upg_tier)
		GameVariables.decreasePlayerMoney(cost)
		updateButtonLabels()
	else:
		print("Not enough money to buy that")
