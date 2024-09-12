extends Camera2D

# Screen shake function using coroutines
func screen_shake(intensity: float = 10.0, duration: float = 0.5, shakes: int = 5) -> void:
	# Start the shake process asynchronously
	call_deferred("_perform_screen_shake", intensity, duration, shakes)

# Internal function to perform the actual shake in the background
func _perform_screen_shake(intensity: float, duration: float, shakes: int) -> void:
	var original_position = position  # Store the original camera position
	var shake_count = shakes  # How many times the camera shakes during the duration

	# Perform the shake without blocking the main thread
	for i in range(shake_count):
		# Generate random shake offsets within the specified intensity
		var shake_offset = Vector2(
			randf_range(-intensity, intensity), 
			randf_range(-intensity, intensity)
		)
		position = original_position + shake_offset

		# Wait for a fraction of the total duration (non-blocking)
		await get_tree().create_timer(duration / shake_count)
	
	# Restore the camera to its original position
	position = original_position
