extends Node2D

@onready var chest_sound = $chestSound
@onready var upgrade_sound = $upgradeSound

func playChestSound():
	chest_sound.play()
	
func playUpgradeSound():
	upgrade_sound.play()
