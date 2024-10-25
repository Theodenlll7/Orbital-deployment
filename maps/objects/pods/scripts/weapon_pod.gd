class_name PodShop extends Control

@export var ammo_cost: int = 50
@export var health_cost: int = 25

@export var weapon_buy_button: PackedScene

@export_dir var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"
@export_dir var explosive_dir: String = "res://inventory/items/explosives/explosive_types/"
@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager
@onready var button_menu: VBoxContainer = $ContentPanelContainer/MarginContainer/VBoxContainer/ScrollContainer/shop
@onready var header_text: Label = $HeaderPanelContainer/MarginContainer/HBoxContainer/Header_Text

enum ShopType { weapon, explosive }

var weapons: Array[WeaponResource] = []
var explosives: Array[ExplosiveResource] = []

var isVisible: bool = false
var pod_type: ShopType = ShopType.weapon

var weapon_path = FilePaths.get_files(weapons_dir, ".tres")
var explosive_path = FilePaths.get_files(explosive_dir, ".tres")


var costumer: Inventory:
	set(value):
		costumer = value
		updatePlayerMoney()
		updateCostLabelColor()


func _ready():
	setRefillAmmonition()
	setRefillHealth()
	
	loadResources()
	update_weapons()
	wave_manager.end_of_wave.connect(update_weapons)


func loadResources():
	for path in weapon_path:
		var _item = ResourceLoader.load(path)
		weapons.append(ResourceLoader.load(path))

	for path in explosive_path:
		explosives.append(ResourceLoader.load(path))


func update_weapons(_time_until_next_wave: float = 0.0):
	weapons.clear()
	for path in weapon_path:
		var _item = ResourceLoader.load(path)
		#if item.weapon_accessibility_wave <= wave:
		weapons.append(ResourceLoader.load(path))

	setLabelsAndCost(pod_type)
	

func setRefillAmmonition():
	var buy_btn: Button = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillAmmonitionPanel/RefillAmmonition
	buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	buy_btn.connect("pressed", _on_refill_ammonition_button_pressed.bind(ammo_cost))


func setRefillHealth():
	var buy_btn: Button = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillHealthPanel/RefillHealth
	buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	buy_btn.connect("pressed", _on_refill_health_button_pressed.bind(health_cost))


func updatePlayerMoney() -> void:
	if costumer:
		var player_money = $HeaderPanelContainer/MarginContainer/HBoxContainer.get_node(
			"Players_money"
		)
		player_money.text = str(costumer.money) + "$"


func compare_items_by_accessibility(item1, item2) -> int:
	if item1.weapon_accessibility_player_level == item2.weapon_accessibility_player_level:
		# If accessibility levels are the same, compare by cost
		return item1.cost < item2.cost
	else:
		# Otherwise, compare by accessibility level
		return item1.weapon_accessibility_player_level < item2.weapon_accessibility_player_level


func setLabelsAndCost(shop_type: ShopType):
	var array_items: Array
	pod_type = shop_type
	
	var refil_ammo_shop_slot: Panel = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillAmmonitionPanel
	var refill_health_shop_slot: Panel = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillHealthPanel

	match shop_type:
		ShopType.weapon:
			array_items = weapons
			array_items.sort_custom(compare_items_by_accessibility)
			
			var ammo_cost_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillAmmonitionPanel/RefillAmmonition/MarginContainer/HBoxContainer/Cost
			ammo_cost_label.text = str(ammo_cost) + " $"
			ammo_cost_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))
			
			refil_ammo_shop_slot.visible = true
			refill_health_shop_slot.visible = false
			header_text.text = "Weapon Pod Station"
			
		ShopType.explosive:
			array_items = explosives
			
			var health_cost_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillHealthPanel/RefillHealth/MarginContainer/HBoxContainer/Cost
			health_cost_label.text = str(health_cost) + " $"
			health_cost_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))
			
			refill_health_shop_slot.visible = true
			refil_ammo_shop_slot.visible = false
			header_text.text = "Explosive Pod Station"


	var shop = $ContentPanelContainer/MarginContainer/VBoxContainer/ScrollContainer/shop

	for existing_child in shop.get_children():
		existing_child.queue_free()
		
	for item in array_items:
		var buy_btn: Button = weapon_buy_button.instantiate()
		var background: Panel = buy_btn.get_child(0)
		var pod_item_container = buy_btn.get_child(1).get_child(0)
		var label: Label = pod_item_container.get_node_or_null("Label")
		var label_unlock: Label = pod_item_container.get_node_or_null("Unlock")
		var cost: Label = pod_item_container.get_node_or_null("Cost")

		label.text = item.item_name
		label_unlock.text = "Level " + str(item.weapon_accessibility_player_level)

		cost.text = "%d $" % item.cost
		cost.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))

		buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
		buy_btn.connect("pressed", _on_button_pressed.bind(item.item_name))

		if item.weapon_accessibility_player_level > ExperiencePoints.current_level:
			buy_btn.disabled = true
			label.set("theme_override_colors/font_color", Color(0.7, 0.7, 0.7))
			var stylebox = StyleBoxFlat.new()
			stylebox.bg_color = Color(0.2, 0.2, 0.2, 0.4)
			background.add_theme_stylebox_override("panel", stylebox)
		shop.add_child(buy_btn)


func updateButtonLabels():
	#var player_money = $HeaderPanelContainer/MarginContainer/HBoxContainer.get_node("Players_money")
	updatePlayerMoney()
	updateCostLabelColor()


func updateCostLabelColor() -> void:
	if !costumer:
		return
	var shop = $ContentPanelContainer/MarginContainer/VBoxContainer/ScrollContainer/shop

	var ammo_cost_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillAmmonitionPanel/RefillAmmonition/MarginContainer/HBoxContainer/Cost
	if costumer.money >= ammo_cost:
		ammo_cost_label.set(
			"theme_override_colors/font_color", Color(31.0 / 255.0, 186.0 / 255.0, 79.0 / 255.0)
		)
	else:
		ammo_cost_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))

	var ammo_health_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/RefillHealthPanel/RefillHealth/MarginContainer/HBoxContainer/Cost
	if costumer.money >= health_cost:
		ammo_health_label.set(
			"theme_override_colors/font_color", Color(31.0 / 255.0, 186.0 / 255.0, 79.0 / 255.0)
		)
	else:
		ammo_health_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))

	for buy_btn in shop.get_children():
		var pod_item_container = buy_btn.get_child(1).get_child(0)
		var cost: Label = pod_item_container.get_node_or_null("Cost")
		if cost:
			if costumer.money >= int(cost.text.split(" ")[0]):
				cost.set(
					"theme_override_colors/font_color",
					Color(31.0 / 255.0, 186.0 / 255.0, 79.0 / 255.0)
				)
			else:
				cost.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1))


func _on_refill_ammonition_button_pressed(cost: int) -> void:
	if costumer.money >= cost:
		costumer.money -= cost
		costumer.add_ammo()
	updateButtonLabels()

func _on_refill_health_button_pressed(cost: int) -> void:
	if costumer.money >= cost:
		costumer.money -= cost
		costumer.actor.health_component.heal(25) 
	updateButtonLabels()


func _on_button_pressed(identifier: StringName) -> void:
	var item = find_item(identifier)
	var cost = item.cost
	handleBuy(item.duplicate(), cost)
	updateButtonLabels()


func find_item(identifier: StringName):
	match pod_type:
		ShopType.explosive:
			return find_explosive(identifier)
		ShopType.weapon:
			return find_weapon(identifier)
	return null


func find_weapon(identifier: StringName) -> WeaponResource:
	for weapon in weapons:
		if weapon.item_name == identifier:
			return weapon
	return null


func find_explosive(identifier: StringName) -> ExplosiveResource:
	for explosive in explosives:
		if explosive.item_name == identifier:
			return explosive
	return null


func handleBuy(item, cost: int):
	if costumer.money >= cost:
		costumer.money -= cost
		costumer.pickup(item)
		if pod_type == ShopType.weapon:
			TooltipHud.show_diffrent_wepons_tips()
			TooltipHud.show_wepon_tip()
		if pod_type == ShopType.explosive:
			TooltipHud.show_explosive_tip()
	else:
		return

func _process(_delta: float) -> void:
	if visible and !isVisible:
		first_btn_focus_grab()
		isVisible = true
	if !visible and isVisible:
		isVisible = false

func first_btn_focus_grab() -> void:
	var first_btn = button_menu.find_child("*Button", true) as Button
	if first_btn:
		first_btn.grab_focus()
