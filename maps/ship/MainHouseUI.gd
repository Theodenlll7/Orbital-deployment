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
	
	var turret_label_cost = $upgradeTurretButton.get_node("Cost")
	turret_label_cost.text = str(GameVariables.getCostOfUpgrade("towerUpgrade")) + "$"
	
	
