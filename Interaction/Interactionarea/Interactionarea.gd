extends Area2D

class_name InteractionArea

@export var action_name: String = "Open"
@export var type: String = "Chest"
@export var dungeon_scene_path: String = "res://MapGeneration/Dungeon/dungeon.tscn" 

var treeStatus = "Fresh"

var isMainUIUp = false

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
			handleMainHouseUI()
		"Tree":
			print("Interacted with tree")
			handleTreeInteraction()
			
signal chest_picked_up

func _on_body_entered(body):
	InteractionManager.register_area(self)

func _on_body_exited(body):
	InteractionManager.unregister_area(self)
	if type == "MainHouse":
		var houseUI = $CanvasLayer
		houseUI.hide()

func play_open_sound():
	SoundEngine.playChestSound()

func handleMainHouseUI():
	var houseUI = $CanvasLayer
	houseUI.show()

func handleTreeInteraction():
	if treeStatus == "Fresh":
		change_sprite_image()
		SoundEngine.playWoodCuttingSound()
		treeStatus = "Cut"
	else: 
		print("Already cut that tree")

func _on_timer_timeout():
	change_sprite_image()
	treeStatus = "Fresh"
	print("treestatus: ", treeStatus)
	$Timer.stop()

func change_sprite_image():
	if treeStatus =="Fresh":
		var sprite = $Sprite2D
		var new_texture = GenerateMapVariables.getRandomTreeSprite()
		sprite.texture = new_texture
		sprite.scale = Vector2(0.05, 0.05)
		$Timer.start(GenerateMapVariables.treeRespawnTime)
		
	else:
		var sprite = $Sprite2D
		var new_texture = GenerateMapVariables.getRandomTreeSprite()
		sprite.texture = new_texture
		sprite.scale = Vector2(GenerateMapVariables.treeScale, GenerateMapVariables.treeScale) 
