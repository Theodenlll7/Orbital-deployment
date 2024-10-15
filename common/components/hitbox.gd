class_name Hitbox extends Area2D

@export var damage: int = 10
@export var cast_shape: Shape2D  # This will be the shape for the hitbox
@export var cast_margin: float = 0.1  # A small margin to avoid tunneling issues

@onready var last_position: Vector2 = global_position

signal hit(hurtbox : Hurtbox)

func _ready() -> void:
	area_entered.connect(_on_area_enterd)

func _on_area_enterd(hurtbox : Hurtbox) -> void:
	if hurtbox:
		hurtbox.damage(damage)
		hit.emit(hurtbox)
