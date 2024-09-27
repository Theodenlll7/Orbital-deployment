class_name AreaEffect extends Node

var targets_in_area: Dictionary = {}

enum ProcessThread { IDLE, PHYSICS }

@export var process_thread: ProcessThread = ProcessThread.IDLE
@export var process_thread_priority: int = 10

@export var group_blacklist: Array[String] = []


func _apply_area_effect(_delta: float):
	pass


func _validate_node(_node: Node):
	pass


func _ready() -> void:
	set_physics_process(process_thread == ProcessThread.PHYSICS)
	set_process(process_thread == ProcessThread.IDLE)
	set_process_priority(process_thread_priority)
	set_physics_process_priority(process_thread_priority)


func _on_body_entered(body: Node) -> void:
	var node = _validate_node(body)
	if node:
		# Ignore characters in blacklisted groups
		for group in group_blacklist:
			if node.is_in_group(group):
				return

		# Increment area count for the node, or add if not present
		if targets_in_area.has(node):
			targets_in_area[node] += 1
		else:
			targets_in_area[node] = 1


func _on_body_exited(body: Node) -> void:
	var node = _validate_node(body)
	if node and targets_in_area.has(node):
		# Decrement the area count
		targets_in_area[node] -= 1

		# Remove node when it has exited all areas
		if targets_in_area[node] <= 0:
			targets_in_area.erase(node)


func _process(delta: float) -> void:
	_apply_area_effect(delta)


func _physics_process(delta: float) -> void:
	_apply_area_effect(delta)
