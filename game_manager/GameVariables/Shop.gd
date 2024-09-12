extends Node
signal purchase_made(name)
func handleBuy(name, cost):
	cost = int(cost)
	if GameVariables.player_money >=cost:
		print("Player just Bought a ", name)
		GameVariables.decreasePlayerMoney(cost)
		emit_signal("purchase_made", name, name, name)
	else:
		print("Not enough money to buy that")


	
