extends Area2D
class_name MeleeAttack
@export var target_group: String = "players"
@export var damage: int = 10
var target: HealthComponent

@export var attack_cooldown: float = 1

var cooldown := attack_cooldown

var can_attack = true


func _ready() -> void:
	var hp = get_parent().get_node_or_null("HealthComponent") as HealthComponent
	hp.died.connect(func(): can_attack = false)


func _process(delta: float) -> void:
	if !can_attack:
		return

	cooldown -= delta
	if target:
		if cooldown <= 0:
			target.damage(damage)
			cooldown = attack_cooldown


func _on_body_entered(body: Node2D) -> void:
	target = body.get_node_or_null("HealthComponent") as HealthComponent


func _on_body_exited(body: Node2D) -> void:
	var hp = body.get_node_or_null("HealthComponent") as HealthComponent
	if target == hp:
		target = null
