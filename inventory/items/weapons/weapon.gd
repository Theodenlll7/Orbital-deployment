extends Node2D
class_name Weapon

@export var weapon_texture_icon: Texture  # Texture associated with the weapon

var weapon_resource: WeaponResource

var audio_player: AudioStreamPlayer


func _init(data: WeaponResource):
	weapon_resource = data


func _ready() -> void:
	var sprite := Sprite2D.new()
	sprite.scale = Vector2(0.8, 0.8)
	sprite.texture = weapon_resource.texture
	add_child(sprite)

	audio_player = AudioStreamPlayer.new()
	audio_player.stream = weapon_resource.audio_steam
	add_child(audio_player)


## Time between shots in seconds
@export var attackRate: float = 0.2

var canAttack: bool = true
var cooldown: float = 0


func _process(delta) -> void:
	if cooldown > 0:
		cooldown -= delta
		if cooldown <= 0:
			canAttack = true

	if (
		canAttack
		and (
			(
				weapon_resource.attack_mode == WeaponResource.AttackMode.AUTOMATIC
				and Input.is_action_pressed("primary_action")
			)
			or (
				weapon_resource.attack_mode == WeaponResource.AttackMode.SINGLE
				and Input.is_action_just_pressed("primary_action")
			)
		)
	):
		weapon_resource.attack.call(self)
		audio_player.play()
		cooldown = weapon_resource.attack_rate
		canAttack = false
