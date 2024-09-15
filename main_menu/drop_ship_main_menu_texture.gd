extends TextureRect
@onready var animation_player_dropship: AnimationPlayer = $"../AnimationPlayer"

# Variables to control the motion
var amplitude  = 50.0  
var speed = 2.0     
var start_position = Vector2()  
var time_elapsed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player_dropship.play("init_dropship")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if animation_player_dropship.current_animation == "":
		if start_position == Vector2():
				start_position = position 
		time_elapsed += delta
		position.y = start_position.y + amplitude * sin(time_elapsed * speed) 
