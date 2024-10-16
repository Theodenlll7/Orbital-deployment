class_name ActionAlert extends MTAction

@export var alert: Node2D
@export var alert_time : float = 0.5

func tick(blackboard: Blackboard) -> int:
	alert.visible = true
	blackboard.actor.get_tree().create_timer(alert_time).timeout.connect(
		func(): alert.visible = false
		)
	return SUCCESS
