@tool
#@icon("../icons/tree.svg")
extends MindTreeNode

class_name MindTreeRoot
enum ProcessThread { PROCESS, PHYSICS }

@export var blackboard := Blackboard.new()

@export var tick_rate: int = 1

@export var process_thread: ProcessThread = ProcessThread.PHYSICS:
	set(value):
		process_thread = value
		set_physics_process(process_thread == ProcessThread.PHYSICS)
		set_process(process_thread == ProcessThread.PROCESS)

var status: int = -1
@onready var last_tick: int = randi_range(0, tick_rate - 1)

func _ready() -> void:
	blackboard.actor = get_parent()

func procces_tree() -> void:
	if skip_tick():
		return

	tick(blackboard)


func tick(blackboard : Blackboard):
	if get_child_count() != 1:
		return FAILURE


func skip_tick() -> bool:
	if last_tick <= tick_rate:
		last_tick += 1
		return true
	last_tick = 0
	return false
