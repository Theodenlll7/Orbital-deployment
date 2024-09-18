extends Node
signal purchase_made(item)


func handleBuy(item, cost: float):
	cost = int(cost)
	if GameVariables.player_money >= cost:
		GameVariables.decreasePlayerMoney(cost)
		purchase_made.emit(item)
	else:
		print("Not enough money to buy that")
