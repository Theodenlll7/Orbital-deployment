class_name Hitbox extends Area2D

@export var damage: int = 10


func _ready() -> void:
	area_entered.connect(_on_area_enterd)


func _on_area_enterd(area: Area2D):
	if area is Hurtbox and !area.is_invulnerable:
		area.damage(damage)
		get_parent().queue_free()
