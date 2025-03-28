class_name MainMenu
extends Control

@onready var select_mission_button: Button = $ContentMarginContainer/MainMenu/NavigationButtons/SelectMissionButton
@onready var player_progress_button: Button = $ContentMarginContainer/MainMenu/NavigationButtons/PlayerProgressButton
@onready var options_button: Button = $ContentMarginContainer/MainMenu/NavigationButtons/OptionsButton
@onready var exit_button: Button = $ContentMarginContainer/MainMenu/NavigationButtons/ExitButton

@onready var spaceship := $ContentMarginContainer/Footer/VBoxContainer/ShipAnchor1/Spaceship

@onready var mission_select_menu: MissionSelect = $ContentMarginContainer/mission_select
@onready var player_progress_menu: Control = $ContentMarginContainer/player_progress
@onready var options_menu: OptionMenu = $ContentMarginContainer/OptionMenu
@onready var main_menu := $ContentMarginContainer/MainMenu

@export var main_menu_spaceship_anchor : Control
@export var mission_spaceship_anchor : Control

@onready var animation_player: AnimationPlayer = $transistion_content/AnimationPlayer
@onready var audio_stream_player_astroids: AudioStreamPlayer = $transistion_content/AudioStreamPlayer
const ASTROID_PASS = preload("res://assets/Sound/UI/astroid_pass.ogg")

@onready var target_menu: Control = main_menu

const LOAD_LEVEL = preload("res://ui/main_menu/loading_level.tscn")

@onready var main_menu_music_audio_stream_player: AudioStreamPlayer = $MainMenuMusicAudioStreamPlayer
const MAIN_MENU_MUSIC = preload("res://assets/Sound/UI/main_menu_music.ogg")
@onready var footer := $ContentMarginContainer/Footer
func _ready() -> void:
	handle_connecting_signals()
	first_btn_focus_grab()
	SaveData.save_player_data()
	TooltipHud.init_vars()
	
	audio_stream_player_astroids.stream = ASTROID_PASS
	audio_stream_player_astroids.bus = "Transition"
	
	main_menu_music_audio_stream_player.stream = MAIN_MENU_MUSIC
	main_menu_music_audio_stream_player.bus = "Music"
	main_menu_music_audio_stream_player.stream.loop = true
	main_menu_music_audio_stream_player.play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and target_menu != main_menu:
		if target_menu == mission_select_menu:
			if mission_select_menu.missions_tab.visible:
				mission_select_menu.on_exit_mission_tab()
			else:
				on_exit_mission_select_menu()
		elif target_menu == options_menu:
			on_exit_options_menu()
		else:
			target_menu = main_menu
			change_menu()


func on_animation_finished(animation_name: String) -> void:
	if animation_name == "to_new_scene":
		change_menu(true)


func on_select_mission_button_pressed() -> void:
	target_menu = mission_select_menu
	animation_player.play("to_new_scene")
	audio_stream_player_astroids.play()
	spaceship.reparent(mission_spaceship_anchor)
	spaceship.start_mission_animation()

func on_exit_mission_select_menu() -> void:
	target_menu = main_menu
	animation_player.play("to_new_scene")
	audio_stream_player_astroids.play()
	print(spaceship)
	spaceship.reparent(main_menu_spaceship_anchor)
	spaceship.start_entrance_animation()

func on_player_progress_button_pressed() -> void:
	target_menu = player_progress_menu
	change_menu()
	
func on_exit_player_progress_menu() -> void:
	target_menu = main_menu
	change_menu()

func on_options_button_pressed() -> void:
	target_menu = options_menu
	change_menu()

func on_exit_options_menu() -> void:
	target_menu = main_menu
	change_menu()

func on_exit_button_pressed() -> void:
	get_tree().quit()

func first_btn_focus_grab() -> void:
	var first_btn = target_menu.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()


func change_menu(show_animation: bool = false) -> void:
	if show_animation:
		animation_player.play("in_new_scene")

	first_btn_focus_grab()

	if target_menu == options_menu:
		main_menu.visible = false
		mission_select_menu.visible = false
		player_progress_menu.visible = false
		options_menu.visible = true
	elif target_menu == mission_select_menu:
		main_menu.visible = false
		mission_select_menu.visible = true
		player_progress_menu.visible = false
		options_menu.visible = false
	elif target_menu == player_progress_menu:
		main_menu.visible = false
		mission_select_menu.visible = false
		player_progress_menu.visible = true
		options_menu.visible = false
	else:
		main_menu.visible = true
		mission_select_menu.visible = false
		player_progress_menu.visible = false
		options_menu.visible = false
	first_btn_focus_grab()

func start_mission(mission_ID: String, marker_position: Vector2) -> void:
	move_ship_to_marker(mission_ID, marker_position)


func move_ship_to_marker(mission_ID: String, move_to: Vector2) -> void:
	#move_to += spaceship.size / 2

	var move_time = 0.5
	var scale_to = 0.1

	var tween = create_tween()
	tween.tween_property(spaceship, "global_position", move_to, move_time).set_ease(Tween.EASE_OUT)
	(
		tween
		. parallel()
		. tween_property(spaceship, "scale", Vector2(scale_to, scale_to), move_time)
		. set_ease(Tween.EASE_OUT)
	)
	tween.connect("finished", Callable(self, "on_tween_finished").bind(mission_ID))


func on_tween_finished(mission_ID: String) -> void:
	var next_scene = LOAD_LEVEL.instantiate()

	if next_scene and mission_ID:
		next_scene.mission_ID = mission_ID        
		get_tree().root.add_child(next_scene)
		get_tree().unload_current_scene()
	else:
		print("Failed to load the level")

func handle_connecting_signals() -> void:
	select_mission_button.button_down.connect(on_select_mission_button_pressed)
	mission_select_menu.back_to_main_menu.connect(on_exit_mission_select_menu)
	mission_select_menu.connect("level_selected", Callable(self, "start_mission"))
	
	player_progress_button.button_down.connect(on_player_progress_button_pressed)
	player_progress_menu.back_to_main_menu.connect(on_exit_player_progress_menu)

	options_button.button_down.connect(on_options_button_pressed)
	options_menu.back_to_main_menu.connect(on_exit_options_menu)

	exit_button.button_down.connect(on_exit_button_pressed)

	var signal_handler = Callable(self, "on_animation_finished")
	animation_player.connect("animation_finished", signal_handler)
