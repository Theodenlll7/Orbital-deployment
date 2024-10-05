extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(_delta):
	animate() 

func _on_health_component_died() -> void:
	# Is not working atm
	pass

func animate() -> void:
	if abs(velocity) > Vector2(0.1, 0.1):
		animated_sprite.play("run_h")
		if velocity.x < 0.0:
			animated_sprite.flip_h = true
		elif velocity.x > 0.0:
			animated_sprite.flip_h = false
	else:
		animated_sprite.play("idle")
