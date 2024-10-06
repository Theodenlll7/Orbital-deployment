class_name ParentMoveAndSlide extends Node

@export var process_thread_priority: int = 100

@onready var parent = get_parent() as CharacterBody2D


func _ready() -> void:
	set_process_priority(process_thread_priority)
	set_physics_process_priority(process_thread_priority)


func _physics_process(_delta: float) -> void:
	parent.move_and_slide()
