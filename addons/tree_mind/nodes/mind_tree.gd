@icon("../icons/tree.svg")
extends MindTreeNode

class_name MindTreeRoot
enum ProcessThread { IDLE, PHYSICS }

@export var tick_rate: int = 1

@export var process_thread: ProcessThread = ProcessThread.PHYSICS

var status: int = -1
@onready var last_tick: int = randi_range(0, tick_rate)

@onready var blackboard := Blackboard.new()


func _ready() -> void:
	blackboard.actor = get_parent()
	set_physics_process(process_thread == ProcessThread.PHYSICS)
	set_process(process_thread == ProcessThread.IDLE)


func _process(delta: float) -> void:
	procces_tree(delta)


func _physics_process(delta: float) -> void:
	procces_tree(delta)


func procces_tree(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	blackboard.delta_time += delta
	if skip_tick():
		return
	tick(blackboard)
	blackboard.delta_time = 0


func tick(blackboard: Blackboard) -> int:
	if get_child_count() != 1:
		return FAILURE
	return get_child(0).tick(blackboard)


func skip_tick() -> bool:
	if last_tick <= tick_rate:
		last_tick += 1
		return true
	last_tick = 0
	return false
