extends Area2D

class_name InteractionArea

@export var action_name: String = "Open"
@export var type: String = "Chest"
@export var dungeon_scene_path: String = "res://MapGeneration/Dungeon/dungeon.tscn" 


var interact: Callable = func():
	match type:
		"DungeonEntrance":
			print("Youve Entered A dungeon: Go to Interaction/interactionarea.gd to make som functionallity for this")
		"Chest":
			print("Interaction/interactionarea.gd")
			play_open_sound()
			emit_signal("chest_picked_up", self)
			queue_free()
		"MainHouse":
			print("Interacted with main house")
		"pod":
			print("Interacted with a pod")
			showUI()
			
signal chest_picked_up

func _on_body_entered(body):
	InteractionManager.register_area(self)

func _on_body_exited(body):
	InteractionManager.unregister_area(self)
	if type == "pod":
		var UI = $CanvasLayer
		UI.hide()

func play_open_sound():
	SoundEngine.playChestSound()

func showUI():
	var houseUI = $CanvasLayer
	houseUI.show()
