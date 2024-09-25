class_name Blackboard extends RefCounted

## Dictionary to store key-value pairs of data
@export var data: Dictionary = {}
var actor: Node
var delta: float = 0


## Sets a value in the blackboard with a key
func set_value(key: String, value: Variant) -> void:
	data[key] = value


## Gets a value from the blackboard by key, with an optional default value
func get_value(key: String, default_value: Variant = null) -> Variant:
	if data.has(key):
		return data[key]
	return default_value


## Checks if a specific key exists in the blackboard
func has_value(key: String) -> bool:
	return data.has(key)


## Removes a specific key and its value from the blackboard
func remove_value(key: String) -> void:
	if data.has(key):
		data.erase(key)


## Clears all data from the blackboard
func clear() -> void:
	data.clear()


## Prints all contents of the blackboard for debugging purposes
func print_contents() -> void:
	for key in data.keys():
		print("Key: ", key, " | Value: ", data[key])


## Merge another dictionary into the blackboard
## If the same key exists, the new value will overwrite the old one
func merge(new_data: Dictionary) -> void:
	for key in new_data.keys():
		data[key] = new_data[key]


## Returns the total number of items stored in the blackboard
func size() -> int:
	return data.size()


## Returns true if the blackboard is empty
func is_empty() -> bool:
	return data.is_empty()


## Example method for blackboard initialization, can be overridden for custom setup
func initialize(default_data: Dictionary = {}) -> void:
	data = default_data.duplicate()


## Updates a value only if the new value is different (optional, useful for performance)
func update_value_if_changed(key: String, new_value: Variant) -> bool:
	if has_value(key) and data[key] == new_value:
		return false
	set_value(key, new_value)
	return true
