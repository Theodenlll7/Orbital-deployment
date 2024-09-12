extends Node
signal purchase_made(item)
func handleBuy(name, cost, item):
	cost = int(cost)
	if GameVariables.player_money >=cost:
		print("Player just Bought a ", name)
		GameVariables.decreasePlayerMoney(cost)
		emit_signal("purchase_made", item)
	else:
		print("Not enough money to buy that")


	
