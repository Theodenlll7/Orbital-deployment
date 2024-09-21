extends Control


func _ready():
	updateButtonLabels()
	setLabelsAndCost()


func setLabelsAndCost():
	var special_equipment = PodVariables.special_equipment
	var orbital_strike_options = $Orbital_strike_UI
	var counter = 0
	for i in range(orbital_strike_options.get_child_count()):
		var button_node = orbital_strike_options.get_child(i)
		var label_node = button_node.get_node("Label")
		var cost_node = button_node.get_node("Cost")
		label_node.text = special_equipment[counter].equipment_name
		cost_node.text = str(special_equipment[counter].equipment_cost)
		counter += 1


func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.player_money) + "$"


func _on_button_pressed(extra_arg_1: int) -> void:
	var special_equipment = PodVariables.special_equipment[extra_arg_1]
	var cost = $Orbital_strike_UI.get_child(extra_arg_1).get_child(1).text

	Shop.handleBuy(special_equipment, cost)
	updateButtonLabels()
