extends ProgressBar

@export var health_component : HealthComponent
@onready var healt_label: Label = $HealtLabel

func _ready() -> void:
	health_component = get_tree().get_first_node_in_group("players").get_node("HealthComponent")
	assert(health_component, get_parent().name + " dose not have a HealthComponent")
	max_value = health_component.max_health
	value = health_component.current_health
	health_component.health_changed.connect(_on_health_component_health_changed)
	health_component.max_health_changed.connect(_on_max_health_changed)

func _on_max_health_changed(new_max) -> void:
	max_value = new_max
	value = new_max
	healt_label.text = str(value) + " hp"


func _on_health_component_health_changed(current_health: Variant) -> void:
	value = value + current_health
	healt_label.text = str(value) + " hp"
	
