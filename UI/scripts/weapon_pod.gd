extends Control

func _ready():
	updateButtonLabels()
	setLabelsAndCost()

func _process(delta):
	pass

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
	player_money.text = str(GameVariables.player_money) + "$"

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


func _on_button_pressed(extra_arg_1: int, extra_arg_2: int) -> void:
	var type = $Weapon_paths.get_child((extra_arg_1)).get_child(extra_arg_2).get_child(0).text
	var cost = $Weapon_paths.get_child((extra_arg_1)).get_child(extra_arg_2).get_child(1).text
	Shop.handleBuy(type, cost)
	updateButtonLabels()
