extends Area2D
class_name melee_attack
@export var target_group : String = "players"
@export var damage : int = 10
var target : HealthComponent

@export var attack_cooldown : float = 1

var cooldown := attack_cooldown

func _process(delta: float) -> void:
	if target:
		cooldown -= delta
		if cooldown <= 0:
			target.damage(damage)
			cooldown = attack_cooldown


func _on_body_entered(body: Node2D) -> void:
	target = body.get_node_or_null("HealthComponent") as HealthComponent

func _on_body_exited(body: Node2D) -> void:
	var hp = body.get_node_or_null("HealthComponent") as HealthComponent
	if target == hp:
		target = null
