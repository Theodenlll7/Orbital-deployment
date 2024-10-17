extends Control
@onready var animations: Control = $Animations
@onready var animated_sprite_2d: AnimatedSprite2D = $Animations/AnimatedSprite2D
@onready var panel: Panel = $Control/Panel
@onready var gpu_particles_2d: GPUParticles2D = $Animations/GPUParticles2D
@onready var godot: Label = $Control/Panel/MarginContainer/VBoxContainer/Godot

const MAIN_MENU_PATH = "res://ui/main_menu/main_menu.tscn"

var animation_done: bool = false

func _ready() -> void:
	godot.modulate.a = 0.0
	ResourceLoader.load_threaded_request(MAIN_MENU_PATH)
	animate()
	
func animate() -> void:
	animated_sprite_2d.play("run_h")
	
	var final_animation_time = 3.0
	
	var animations_global_position: Vector2 = animations.global_position
	var walk_dist: float = panel.size.x + 800.0 
	
	var tween_label = create_tween()
	tween_label.tween_property(godot, "modulate:a", 1, final_animation_time - 1.0)
	
	var tween_animation = create_tween()
	tween_animation.tween_property(animations, "global_position", animations_global_position + Vector2(walk_dist, 0), final_animation_time)
	tween_animation.connect("finished", stop_animation)

func stop_animation() -> void:
	animated_sprite_2d.stop()
	gpu_particles_2d.emitting = false
	animation_done = true

func load_to_main_menu() -> void:
	var packed_scene = ResourceLoader.load_threaded_get(MAIN_MENU_PATH)
	if packed_scene:
		get_tree().change_scene_to_packed(packed_scene)


func _process(_delta: float) -> void:
	var progress: Array = []
	ResourceLoader.load_threaded_get_status(MAIN_MENU_PATH, progress)
	if progress[0] >= 1 && animation_done:
		load_to_main_menu()
		
