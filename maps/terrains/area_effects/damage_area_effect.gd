class_name DamageAreaEffect2D extends AreaEffect

@export var damage: int = 20
@export var damage_cooldown: float = 1
@export var damage_first_cooldown: float = 0.2

var targets_with_cooldowns: Array[TargetEntry] = []


class TargetEntry:
	var target: HealthComponent
	var cooldown: float = 0.0


func _validate_node(node: Node):
	var entry = TargetEntry.new()
	entry.target = node.get_node_or_null("HealthComponent") as HealthComponent
	entry.cooldown = damage_first_cooldown
	if entry.target:
		if !targets_in_area.has(entry.target):
			targets_with_cooldowns.append(entry)
		return entry.target


func _apply_area_effect(delta: float):
	# Temporary array to collect entries to remove
	var entries_to_remove = []

	for entry in targets_with_cooldowns:
		if !targets_in_area.has(entry.target):
			entries_to_remove.append(entry)
			continue

		entry.cooldown -= delta

		# Apply damage if cooldown has expired
		if entry.cooldown <= 0.0:
			entry.target.damage(damage)
			entry.cooldown = damage_cooldown

	# Remove targets that are no longer in the area
	for entry in entries_to_remove:
		targets_with_cooldowns.erase(entry)
