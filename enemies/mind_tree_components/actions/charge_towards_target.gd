class_name ChargeTowardsTarget extends MTAction

@export var charge_animated_sprite: AnimatedSprite2D
@export_range(0.1, 2) var charge_time: float = 0.8

var charge_timer: float = 0

var is_charging := false


func tick(blackboard: Blackboard) -> int:
	var target = blackboard.get_value("target")
	if !target:
		return FAILURE

	if is_charging:
		charge_timer += blackboard.delta_time
		if charge_timer >= charge_time:
			charge_animated_sprite.visible = false
			charge_timer = 0
			is_charging = false
			return SUCCESS
		else:
			charge_animated_sprite.look_at(target.global_position)

			var space_state = blackboard.actor.get_world_2d().direct_space_state
			var query = PhysicsRayQueryParameters2D.create(
				charge_animated_sprite.global_position, target.global_position, 32, [self]
			)
			var result = space_state.intersect_ray(query)
			var target_position = target.global_position
			if result:
				target_position = result["position"]

			charge_animated_sprite.scale.x = charge_animated_sprite.global_position.distance_to(
				target_position
			)
			return RUNNING
	else:
		is_charging = true
		charge_animated_sprite.play("charge")
		charge_animated_sprite.speed_scale = 1 / charge_time
		charge_animated_sprite.visible = true
		return RUNNING
