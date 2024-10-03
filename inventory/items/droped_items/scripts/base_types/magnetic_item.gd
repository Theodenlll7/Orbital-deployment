extends Area2D
class_name MagneticItem

# Variables to adjust
var player: Player = null
var inventory: Inventory = null
const speed: float = 500
const pick_up_distance: float = 5

var velocity := Vector2.ZERO


func _init(pick_up_radius: float = 50, texture: Texture2D = null):
	var collider = CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = pick_up_radius
	collider.shape = shape
	add_child(collider)

	var sprite = Sprite2D.new()
	sprite.texture = texture


func _physics_process(delta: float) -> void:
	if player and pick_up_condition():
		var distance_to_player = position.distance_to(player.position)

		# Check if close enough to pick up
		if distance_to_player < pick_up_distance:
			pick_up_item()
			return

		var direction = (player.position - position).normalized()

		var accel = direction * speed

		velocity += accel * delta

		if distance_to_player < 50:
			velocity = lerp(velocity, accel, 0.1)

		position += velocity * delta


func pick_up_condition() -> bool:
	printerr(
		"'pick_up_condition' is a function in 'MagneticItem' that is to be overwriten in subclass"
	)
	return true


func pick_up_item():
	printerr("'pick_up_item' is a function in 'MagneticItem' that should be overwriten in subclass")
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if player == null:
			player = body as Player
			inventory = player.inventory
		elif !pick_up_condition():
			player = body as Player
			inventory = player.inventory


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		inventory = null
