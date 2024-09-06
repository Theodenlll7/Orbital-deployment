extends Area2D

signal interacted

@export var interactable := true
@export var interaction_text := "Interact"


# Called when the object is ready
func _ready():
	# Ensure the Area2D has a collision shape for detection
	if not $CollisionShape2D:
		print("Warning: No CollisionShape2D attached to Interactable")
	set_process_input(true)

# Mouse enters the interactable object area
func _on_mouse_entered():
	if interactable:
		_show_interaction_prompt()

# Mouse exits the interactable object area
func _on_mouse_exited():
	_hide_interaction_prompt()

# Process input to detect interaction
func _input(event):
	if interactable and event.is_action_pressed("interact"):
		_on_interact()

# Show interaction prompt (could be a UI or just text pop-up)
func _show_interaction_prompt():
	# For example, display interaction text
	print(interaction_text)

# Hide interaction prompt
func _hide_interaction_prompt():
	print("")

# Handle the interaction
func _on_interact():
	# Emit the interacted signal, other objects can listen to this signal
	emit_signal("interacted")
	# You can also call additional logic here (play sound, animation, etc.)
	print("Interacted with object")
