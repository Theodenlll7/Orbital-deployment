extends ProgressBar

@export var health_component : HealthComponent

func _ready() -> void:
	health_component = get_tree().get_first_node_in_group("players").get_node("HealthComponent")
	assert(health_component, get_parent().name + " dose not have a HealthComponent")
	value = health_component.current_health
	health_component.health_changed.connect(_on_health_component_health_changed)

func _on_health_component_health_changed(current_health: Variant) -> void:
	value = value + current_health
