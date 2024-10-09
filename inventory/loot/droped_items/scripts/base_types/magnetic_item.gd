extends Area2D
class_name MagneticItem

# Variables to adjust
var player: Player = null
const speed: float = 500
const pick_up_distance: float = 5

var magnet_radius: float = 50

var velocity := Vector2.ZERO

var pickup_condition: Callable
var pickup_item: Callable

var item: Item

var timer : Timer

func _init(p_item: Item, pick_up_radius: float = 50):
	magnet_radius = pick_up_radius
	item = p_item


func _ready() -> void:
	z_index = 1
	var collider := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = magnet_radius
	collider.set_deferred("shape", shape)
	add_child(collider)

	var sprite = Sprite2D.new()
	sprite.texture = item.texture
	sprite.scale = Vector2(0.3, 0.3)

	pickup_condition = item.pickup_condition
	pickup_item = item.pickup_item

	add_child(sprite)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 15
	timer.timeout.connect(_item_despawn)
	timer.start()

# Despawn function with blinking effect
func _item_despawn():
	# Create a Tween for the blinking effect
	var tween = create_tween()
	print("Dee spawn")
	# Blink for 5 seconds (on/off every 0.5 seconds)
	var blink_time = 3.0
	var blink_frequency = 0.2
	var showItem = false
	for i in range(int(blink_time / blink_frequency)):
		tween.tween_property(self ,"visible", showItem, blink_frequency)
		showItem = !showItem
	
	# After blinking, remove the item
	tween.tween_callback(queue_free)

	# Start the tween animations
	tween.play()


func _physics_process(delta: float) -> void:
	if player and pickup_condition.call(player):
		var distance_to_player = position.distance_to(player.position)

		# Check if close enough to pick up
		if distance_to_player < pick_up_distance:
			pickup_item.call(player)
			queue_free()
			return

		var direction = (player.position - position).normalized()

		var accel = direction * speed

		velocity += accel * delta

		if distance_to_player < 50:
			velocity = lerp(velocity, accel, 0.1)

		position += velocity * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		if player == null:
			player = body as Player
		elif !pickup_condition.call(player):
			player = body as Player


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
