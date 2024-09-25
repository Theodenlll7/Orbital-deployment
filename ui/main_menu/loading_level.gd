extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var loading_text: Label = $Control/Label/MarginContainer/loadingText

var time: float = 0.0;
var sinTime: float = 0.0
var speed: float = 2.0
var minOpacity = 0.2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("loading_animation")

func flashLoadingText(sinTime: float) -> void:
	loading_text.modulate.a = sinTime

func _process(delta: float) -> void:
	time += delta
	sinTime = minOpacity + (1 - minOpacity) * ((sin(time * speed) + 1) * 0.5)
	flashLoadingText(sinTime)
