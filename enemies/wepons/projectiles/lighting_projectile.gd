extends Node2D


func _ready() -> void:
	play_bullet_animation()
	play_bullet_sound()

func play_bullet_sound():
	if $AudioStreamPlayer:
		$AudioStreamPlayer.play()
	
	
func play_bullet_animation():
	if $AnimatedSprite2D:
		$AnimatedSprite2D.play("default")
