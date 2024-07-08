extends Node2D

@onready var chest_sound = $chestSound

func playChestSound():
	chest_sound.play()
