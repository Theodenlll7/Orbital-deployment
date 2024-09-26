extends Camera2D

var follow_strength: float = 100.0  
var lerp_factor: float = 1000.0     

func screen_shake(_intensity: float = 10.0, _duration: float = 0.5, _shakes: int = 5) -> void:
	pass

func move_camera_in_game() -> void:
	var mouse_pos_2d = get_viewport().get_mouse_position()
	var mouse_offset = mouse_pos_2d - get_viewport().get_visible_rect().size / 2
	var target_position = mouse_offset.normalized() * follow_strength
	
	position = lerp(Vector2(), target_position, mouse_offset.length() / lerp_factor)	

func _process(delta: float) -> void:
	move_camera_in_game()
