extends Control

func _ready():
	updateButtonLabels()
	setLabelsAndCost()

func _process(delta):
	pass

func setLabelsAndCost():
	var explosives = PodVariables.explosives
	var grenade_options = $Grenades_options_UI
	var counter = 0
	for i in range(grenade_options.get_child_count()):
		var button_node = grenade_options.get_child(i)
		var label_node = button_node.get_node("Label")
		var cost_node = button_node.get_node("Cost")
		label_node.text = explosives[counter].explosive_name
		cost_node.text = str(explosives[counter].explosive_cost)
		counter+=1
		
func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.player_money) + "$"
	

func _on_button_pressed(extra_arg_1: int) -> void:
	var explosive = PodVariables.explosives[extra_arg_1]
	var name = $Grenades_options_UI.get_child((extra_arg_1)).get_child(0).text
	var cost = $Grenades_options_UI.get_child((extra_arg_1)).get_child(1).text
	Shop.handleBuy(name, cost, explosive)
	updateButtonLabels()
