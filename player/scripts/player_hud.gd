extends CanvasLayer

class_name PlayerHUD

@export_group("Weapon Slots")
@export var weapon_slots: Array[AspectRatioContainer] = [null, null]
@export var selected_size: float = 1.0
@export var deselected_size: float = 0.5

@onready var mony_label: Label = $PlayerHUD/monyIndicator/mony
@onready var wave_number: Label = $PlayerHUD/WaveIndicator/WaveNumber

@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager
@export var ammo_indicator: AmmoIndicator = null

const INVENTORY_SLOT = preload("res://inventory/sprites/inventory_slot.png")
const SELECTED_INVENTORY_SLOT = preload("res://inventory/sprites/selected_inventory_slot.png")

var selected_slot = -1
@onready var pause_in_game_menu: Control = $PauseInGameMenu
var paused: bool = false


func _ready() -> void:
	wave_manager.new_wave_started.connect(new_wave)
	wave_number.text = str(wave_manager.wave)

	GameVariables.money_updated.connect(update_money_display)
	mony_label.text = str(GameVariables.player_money)
	
	
	for slot in weapon_slots.size():
		deselect_weapon_slot(slot)

func new_wave(wave: int):
	wave_number.text = str(wave)


func select_weapon_slot(index: int) -> void:
	weapon_slots[index].get_node("Frame").texture = SELECTED_INVENTORY_SLOT
	#weapon_slots[index].scale = Vector2(selected_size, selected_size)
	deselect_weapon_slot(selected_slot)
	selected_slot = index


func deselect_weapon_slot(index: int) -> void:
	if index < 0 or weapon_slots.size() < index:
		return
	weapon_slots[index].get_node("Frame").texture = INVENTORY_SLOT
	#weapon_slots[index].scale = Vector2(deselected_size, deselected_size)

func update_money_display(new_money_value: int) -> void:
	mony_label.text = str(new_money_value)


func equip_weapon(slot_index: int, weapon: WeaponResource):
	var slot = weapon_slots[slot_index]
	var icon: TextureRect = slot.get_node("Icon")
	icon.texture = weapon.texture


func equip_explosive(explosive: ExplosiveResource):
	var slot = $PlayerHUD/HBoxContainer2.get_child(0).get_child(0)
	var icon: TextureRect = slot.get_node("Icon")
	icon.texture = explosive.texture

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_in_game_menu.visible = false
		Engine.time_scale = 1
	else:
		pause_in_game_menu.visible = true
		Engine.time_scale = 0
	paused = !paused
