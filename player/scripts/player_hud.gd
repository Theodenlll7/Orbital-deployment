extends CanvasLayer

class_name PlayerHUD

@export_group("Weapon Slots")
@export var weapon_slots: Array[AspectRatioContainer] = [null, null]
@export var selected_size: float = 1.0
@export var deselected_size: float = 0.5

@onready var money_label: Label = $MarginContainer/PlayerHUD/MoneyHUD/mony

@onready var wave_number: Label = $MarginContainer/PlayerHUD/WaveHUD/WaveHBoxContainer/WaveNumber

@onready var remaining_text: Label = $MarginContainer/PlayerHUD/WaveHUD/WaveInfoHBoxContainer/RemainingText
@onready var remaining_number: Label = $MarginContainer/PlayerHUD/WaveHUD/WaveInfoHBoxContainer/RemainingNumber

@onready var time_h_box_container: HBoxContainer = $MarginContainer/PlayerHUD/WaveHUD/TimeHBoxContainer
@onready var time_until_next_wave_label: Label = $MarginContainer/PlayerHUD/WaveHUD/TimeHBoxContainer/TimeUntilNextWave
@onready var wepon_name_label: Label = $MarginContainer/PlayerHUD/GameHUD/HBoxContainer2/WeponNameLabel

@onready var information_hud: VBoxContainer = $MarginContainer/PlayerHUD/InformationHUD

@onready var explosive_container : ExplosiveContainer = $MarginContainer/PlayerHUD/GameHUD/HBoxContainer/ExplosiveContainer

@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager
@export var ammo_indicator: AmmoIndicator = null

const INVENTORY_SLOT = preload("res://inventory/sprites/inventory_slot.png")
const SELECTED_INVENTORY_SLOT = preload("res://inventory/sprites/selected_inventory_slot.png")

var selected_slot = -1
@onready var pause_in_game_menu: Control = $PauseInGameMenu
var paused: bool = false
@onready var death_screen: Control = $DeathScreen

var countdown_time = 0.0
signal money_updated

func _ready() -> void:
	wave_manager.new_wave_started.connect(new_wave)
	wave_manager.end_of_wave.connect(between_waves)
	wave_manager.nr_of_enemies.connect(set_hostiles)
	
	TooltipHud.show_tip.connect(show_tooltip)
	
	between_waves(wave_manager.in_between_wave_time)
	wave_number.text = str(wave_manager.wave)
	

	for slot in weapon_slots.size():
		deselect_weapon_slot(slot)

func set_wepon_name(weapon_name: String) -> void:
	wepon_name_label.text = str(weapon_name)

func new_wave(wave: int):
	wave_number.text = str(wave)

func between_waves(time: float):
	countdown_time = time
	time_h_box_container.show()  
	set_hostiles(0)
	update_timer_display(countdown_time)

func select_weapon_slot(index: int) -> void:
	weapon_slots[index].get_node("Frame").texture = SELECTED_INVENTORY_SLOT
	#weapon_slots[index].scale = Vector2(selected_size, selected_size)
	deselect_weapon_slot(selected_slot)
	selected_slot = index

func set_hostiles(remaining: int) -> void:
	if remaining > 0:
		remaining_number.visible = true
		remaining_text.text = "Remaining hostiles"
		remaining_number.text = str(remaining)
	else:
		remaining_text.text = "Prepare for the Next Wave"
		remaining_number.text = ""
		remaining_number.visible = false

func deselect_weapon_slot(index: int) -> void:
	if index < 0 or weapon_slots.size() < index:
		return
	weapon_slots[index].get_node("Frame").texture = INVENTORY_SLOT
	#weapon_slots[index].scale = Vector2(deselected_size, deselected_size)


func update_money_display(new_money_value: int) -> void:
	money_label.text = str(new_money_value)
	money_updated.emit()

func equip_weapon(slot_index: int, weapon: WeaponResource):
	var slot = weapon_slots[slot_index]
	var icon: TextureRect = slot.get_node("Icon")
	icon.texture = weapon.texture


func equip_explosive(explosive: ExplosiveResource):
	if explosive:
		explosive_container.set_icon(explosive.texture)
		explosive_container._count_changed(explosive.explosive_count)
		explosive.count_changed.connect(explosive_container._count_changed)
	else: explosive_container.set_icon(null)

func update_timer_display(newValue: float) -> void:
	if newValue < 4.0:
		time_until_next_wave_label.modulate = Color("#d2202c")
	else: 
		time_until_next_wave_label.modulate = Color("#FFFFFF")
	time_until_next_wave_label.text = str(int(newValue)) + "s"

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

	if countdown_time > 0.0:
		countdown_time -= delta  
		update_timer_display(countdown_time)  
		if countdown_time <= 0.0:
			countdown_time = 0.0
			time_h_box_container.hide()
		
func pauseMenu():
	if death_screen.visible:
		paused = true
	
	if paused:
		pause_in_game_menu.visible = false
		Engine.time_scale = 1
	else:
		pause_in_game_menu.visible = true
		Engine.time_scale = 0
	paused = !paused


func _on_inventory_weapon_swap(_index: int, weapon: WeaponResource) -> void:
	set_wepon_name(weapon.item_name)

func show_tooltip(tip: String) -> void:
	var fade_time = 1
	var visible_time = 4
	var label: RichTextLabel = $MarginContainer/PlayerHUD/InformationHUD/MarginContainer/Panel/MarginContainer/VBoxContainer/Text
	var tween = create_tween()

	label.clear()
	label.append_text(tip)
	
	tween.tween_property(information_hud, "modulate:a", 1.0, fade_time)
	tween.chain().tween_property(information_hud, "modulate:a", 1.0, visible_time)
	tween.chain().tween_property(information_hud, "modulate:a", 0.0, fade_time)
