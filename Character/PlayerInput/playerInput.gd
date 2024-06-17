extends Node2D

var menu_open = false

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_pressed("escape"):
		on_escape_pressed()
	
	if Input.is_action_pressed("1"):
		on_key_pressed(1)
	
	if Input.is_action_pressed("2"):
		on_key_pressed(2)
	
	if Input.is_action_pressed("3"):
		on_key_pressed(3)
	
	if Input.is_action_pressed("4"):
		on_key_pressed(4)

func on_escape_pressed():
	get_tree().quit() 


func on_key_pressed(number):

	match number:
		1:
			print("Key 1 pressed")

		2:
			print("Key 2 pressed")
			
		3:
			print("Key 3 pressed")
			
		4:
			print("Key 4 pressed")
			
