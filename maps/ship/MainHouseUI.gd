extends Control

func _ready():
	updateButtonLabels()

func _process(delta):
	pass


func _on_upgrade_mele_button_pressed():
	GameVariables.upgradeFromShip("meleeUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()

func _on_upgrade_range_button_pressed():
	GameVariables.upgradeFromShip("rangeUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()

func _on_upgrade_turret_button_pressed():
	GameVariables.upgradeFromShip("towerUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()

func _on_upgrade_base_button_pressed():
	GameVariables.upgradeFromShip("shipUpgrade")
	updateButtonLabels()
	SoundEngine.playUpgradeSound()


func updateButtonLabels():
	var mele_label_cost = $upgradeMeleButton.get_node("Cost")
	mele_label_cost.text = str(GameVariables.getCostOfUpgrade("meleeUpgrade")) + "$"
	
	var range_label_cost = $upgradeRangeButton.get_node("Cost")
	range_label_cost.text = str(GameVariables.getCostOfUpgrade("rangeUpgrade")) + "$"
	
	var turret_label_cost = $upgradeTurretButton.get_node("Cost")
	turret_label_cost.text = str(GameVariables.getCostOfUpgrade("towerUpgrade")) + "$"
	
	var base_label_cost = $upgradeBaseButton.get_node("Cost")
	base_label_cost.text = str(GameVariables.getCostOfUpgrade("shipUpgrade")) + "$"
