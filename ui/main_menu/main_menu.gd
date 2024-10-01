class_name MainMenu
extends Control

@onready var select_mission_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/SelectMissionButton
@onready var player_progress_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/PlayerProgressButton
@onready var options_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/OptionsButton
@onready var exit_button: Button = $ContentMarginContainer/HBoxContainer/VBoxContainer/ExitButton

@onready var ship: Control = $ship
@onready var ship_texture: TextureRect = $ship/DropShipTextureRect
@onready var animation_player_ship: AnimationPlayer = $ship/AnimationPlayer

@onready var mission_select_menu: MissionSelect = $mission_select
@onready var player_progress_menu: Control = $player_progress
@onready var options_menu: OptionsMenu = $options_menu
@onready var main_menu: MarginContainer = $ContentMarginContainer

@onready var animation_player: AnimationPlayer = $transistion_content/AnimationPlayer

@onready var target_menu: Control = main_menu

const load_level = preload("res://ui/main_menu/loading_level.tscn")
var ship_start_position: Vector2


func _ready() -> void:
	handle_connecting_signals()
	first_btn_focus_grab()
	ship_start_position = ship.global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and target_menu != main_menu:
		if target_menu == mission_select_menu:
			if mission_select_menu.missions_tab.visible:
				mission_select_menu.on_exit_mission_tab()
			else:
				target_menu = main_menu
				change_menu()
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


func on_exit_mission_select_menu() -> void:
	target_menu = main_menu
	animation_player.play("to_new_scene")

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
	reset_ship()

	if target_menu == options_menu:
		main_menu.visible = false
		mission_select_menu.visible = false
		player_progress_menu.visible = false
		options_menu.visible = true
	elif target_menu == mission_select_menu:
		animation_player_ship.play("select_mission_ship_position")
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
		animation_player_ship.play("init_dropship")
		main_menu.visible = true
		mission_select_menu.visible = false
		player_progress_menu.visible = false
		options_menu.visible = false
	first_btn_focus_grab()

func start_mission(mission_ID: String, marker_position: Vector2) -> void:
	move_ship_to_marker(mission_ID, marker_position)


func move_ship_to_marker(mission_ID: String, move_to: Vector2) -> void:
	move_to = ship.global_position + move_to - Vector2(80.0, 80.0)

	var move_time = 0.5
	var scale_to = 0.6

	var tween = create_tween()
	tween.tween_property(ship, "global_position", move_to, move_time).set_ease(Tween.EASE_OUT)
	(
		tween
		. parallel()
		. tween_property(ship_texture, "scale", Vector2(scale_to, scale_to), move_time)
		. set_ease(Tween.EASE_OUT)
	)
	tween.connect("finished", Callable(self, "on_tween_finished").bind(mission_ID))


func on_tween_finished(mission_ID: String) -> void:
	var next_scene = load_level.instantiate()

	if next_scene and mission_ID:
		next_scene.mission_ID = mission_ID        
		get_tree().root.add_child(next_scene)
		get_tree().unload_current_scene()
	else:
		print("Failed to load the level")

func reset_ship() -> void:
	ship_texture.scale = Vector2(1.0, 1.0)
	ship.global_position = ship_start_position
	ship_texture.visible = true

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
