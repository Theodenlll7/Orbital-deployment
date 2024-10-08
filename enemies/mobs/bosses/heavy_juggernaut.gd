extends CharacterBody2D

@onready var health_stats = $HealthComponent
@onready var movement_stats = $MindTreeRoot/Selector/SelectAndWalktToTarget/StartNavgationToTarget
@onready var weapon = $MobWeapon
@onready var spawn_sound = $Sound/spawn

#Base stats
var movement_speed: float = 20
var size_scale = 3
var max_health = 1000


func _ready() -> void:
	_set_boss_base_variables()
	spawn_sound.play()
	
func _set_boss_base_variables():
	set_health()
	set_up_weapon()
	movement_stats.move_speed = movement_speed
	scale = Vector2(size_scale, size_scale)

func set_health():
	health_stats.max_health = max_health
	health_stats.current_health = max_health

func set_up_weapon():
	weapon.accuracy = 1
	weapon.scale = Vector2(1/size_scale, 1/size_scale)
