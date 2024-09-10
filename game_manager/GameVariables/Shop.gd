extends Node

func handleBuy(type, cost):
	cost = int(cost)
	if GameVariables.player_money >=cost:
		print("Player just Bought a ", type)
		GameVariables.decreasePlayerMoney(cost)
	else:
		print("Not enough money to buy that")
