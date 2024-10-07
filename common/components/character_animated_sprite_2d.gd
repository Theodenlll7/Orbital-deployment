class_name CharacterAnimatedSprite2D extends AnimatedSprite2D

@onready var parent = get_parent() as CharacterBody2D

var dead = false


func _ready() -> void:
	var hp = parent.get_node("HealthComponent") as HealthComponent
	hp.died.connect(func():
		stop()
		dead = true
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !dead:
		animate()


func animate() -> void:
	if abs(parent.velocity) > Vector2(0.1, 0.1):
		play("run_h")
		if parent.velocity.x > 0.0:
			flip_h = true
		elif parent.velocity.x < 0.0:
			flip_h = false
	else:
		play("idle")
