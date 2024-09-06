extends Node2D

@onready var chest_sound = $chestSound
@onready var upgrade_sound = $upgradeSound
@onready var woodCutting_sound = $woodCuttingSound

func playChestSound():
	chest_sound.play()
	
func playUpgradeSound():
	upgrade_sound.play()
	
func playWoodCuttingSound():
	woodCutting_sound.play()
