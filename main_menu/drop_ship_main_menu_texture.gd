extends TextureRect

# Variables to control the motion
var amplitude  = 50.0  
var speed = 2.0     
var start_position = Vector2()  
var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = position 
	#animation_player.play("fly_in_from_left")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#if animation_player.current_animation == "":
	time_elapsed += delta
	position.y = start_position.y + amplitude * sin(time_elapsed * speed) 
