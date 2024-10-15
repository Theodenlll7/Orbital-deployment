extends Node

@export var root_path: NodePath

@onready var sounds: Dictionary = {
	"UI_btn_hover":  {"player": AudioStreamPlayer.new(), "type": "hover"},
	"UI_btn_click": {"player": AudioStreamPlayer.new(), "type": "click" }
}

@onready var sound_paths: Dictionary = { 
	"hover": preload("res://assets/Sound/UI/UI_btn_hover.ogg"),
	"click": preload("res://assets/Sound/UI/UI_btn_click.ogg")
}


# See YT Liblast for code
func _ready() -> void:
	if root_path == null:
		print("Empty root path for UI sounds!")
		return 
	for key in sounds.keys():
		print(key)
		var sound_type = sounds[key]["type"]
		sounds[key]["player"].stream = sound_paths[sound_type]
		sounds[key]["player"].bus = "UI"
		
		add_child(sounds[key]["player"])
	init_sounds(get_node(root_path))

func init_sounds(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(play_sfx.bind("UI_btn_hover"))
			child.button_down.connect(play_sfx.bind("UI_btn_click"))
		if child is TabContainer:
			child.tab_button_pressed.connect(play_sfx.bind("UI_btn_click"))
		if child is TextureButton:
			child.mouse_entered.connect(play_sfx.bind("UI_btn_hover"))
			child.button_down.connect(play_sfx.bind("UI_btn_click"))
		# recursion
		init_sounds(child)

func play_sfx(sound_key: String) -> void:
	var sound: AudioStream = sounds[sound_key]["player"].stream
	var player = AudioStreamPlayer.new()
	
	player.stream = sound
	player.bus = "UI"
	
	add_child(player)
	
	player.play()
	player.connect("finished", Callable(player, "queue_free"))
	
