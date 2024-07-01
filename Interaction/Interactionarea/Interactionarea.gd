extends Area2D

class_name InteractionArea

@export var action_name: String = "Open"
@export var type: String = "Chest"

@export var dungeon_scene_path: String = "res://MapGeneration/Dungeon/dungeon.tscn" 

var interact: Callable = func():
	if type == "Dungeon":
		print("Youve Entered A dungeon")
	else:
		play_open_sound()
		emit_signal("chest_picked_up", self)
		destroy_after_delay()
	
signal chest_picked_up

func _on_body_entered(body):
	InteractionManager.register_area(self)

func _on_body_exited(body):
	InteractionManager.unregister_area(self)

func play_open_sound():
	var audio_player = $AudioStreamPlayer
	if audio_player and audio_player.stream:
		audio_player.play()

func destroy_after_delay():
	$Timer.start() 
	
func _on_timer_timeout():
	queue_free()
	
