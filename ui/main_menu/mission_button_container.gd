extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_visibility_changed)

func _visibility_changed() -> void:
	if visible:
		for child in get_children():
			var button = child as Button
			if button:
				button.grab_focus()
				break
