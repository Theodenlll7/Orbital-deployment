class_name Hitbox extends Area2D

@export var damage: int = 10

signal hit(hurtbox: Hurtbox)


func _ready() -> void:
	area_entered.connect(_on_area_enterd)


func _on_area_enterd(hurtbox: Hurtbox) -> void:
	if hurtbox:
		hurtbox.damage(damage)
		hit.emit(hurtbox)
