class_name ParentMoveAndSlide extends Node

@onready var parent = get_parent() as CharacterBody2D


func _physics_process(_delta: float) -> void:
	parent.move_and_slide()
