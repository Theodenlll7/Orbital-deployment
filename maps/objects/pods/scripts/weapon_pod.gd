class_name PodShop extends Control

@export var ammo_cost: int = 225

@export var weapon_buy_button: PackedScene

@export_dir var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"
@export_dir var explosive_dir: String = "res://inventory/items/explosives/explosive_types/"
@onready var wave_manager = get_tree().get_nodes_in_group("wave_manager")[0] as WaveManager


enum ShopType { weapon, explosive }

var weapons: Array[WeaponResource] = []
var explosives: Array[ExplosiveResource] = []

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
	loadResources()
	update_weapons()
	wave_manager.end_of_wave.connect(update_weapons)


func loadResources():
	for path in weapon_path:
		var item = ResourceLoader.load(path)
		weapons.append(ResourceLoader.load(path))

	for path in explosive_path:
		explosives.append(ResourceLoader.load(path))

func update_weapons(_time_until_next_wave: float = 0.0):
	weapons.clear()
	for path in weapon_path:
		var item = ResourceLoader.load(path)
		#if item.weapon_accessibility_wave <= wave:
		weapons.append(ResourceLoader.load(path))
			
	setLabelsAndCost(ShopType.weapon)
	
func setRefillAmmonition():
	var buy_btn: Button = $ContentPanelContainer/MarginContainer/VBoxContainer/Panel/RefillAmmonition
	buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
	buy_btn.connect("pressed", _on_refill_ammonition_button_pressed.bind(ammo_cost))

func updatePlayerMoney() -> void:
		if costumer:
			var player_money = $HeaderPanelContainer/MarginContainer/HBoxContainer.get_node("Players_money")	
			player_money.text = str(costumer.money) + "$"

func compare_items_by_accessibility(item1, item2) -> int:
	return item1.weapon_accessibility_player_level < item2.weapon_accessibility_player_level

func setLabelsAndCost(shop_type: ShopType):
	var array_items: Array
	pod_type = shop_type
	match shop_type:
		ShopType.weapon:
			array_items = weapons
		ShopType.explosive:
			array_items = explosives

	var shop = $ContentPanelContainer/MarginContainer/VBoxContainer/ScrollContainer/shop
	
	for existing_child in shop.get_children():
		existing_child.queue_free()
		
	if shop_type != ShopType.weapon:
		var refil_ammo_shop_slot: Panel = $ContentPanelContainer/MarginContainer/VBoxContainer/Panel
		refil_ammo_shop_slot.visible = false
	else:
		var ammo_cost_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/Panel/RefillAmmonition/MarginContainer/HBoxContainer/Cost
		ammo_cost_label.text = str(ammo_cost) + " $"
		ammo_cost_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1)) 
		
	
	array_items.sort_custom(compare_items_by_accessibility)
	for item in array_items:
		var buy_btn: Button = weapon_buy_button.instantiate()
		var pod_item_container = buy_btn.get_child(0).get_child(0)  
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
		
		shop.add_child(buy_btn)


func updateButtonLabels():
	#var player_money = $HeaderPanelContainer/MarginContainer/HBoxContainer.get_node("Players_money")
	updatePlayerMoney()
	updateCostLabelColor()
	
func updateCostLabelColor() -> void:
	if !costumer: return
	var shop = $ContentPanelContainer/MarginContainer/VBoxContainer/ScrollContainer/shop
	
	var ammo_cost_label: Label = $ContentPanelContainer/MarginContainer/VBoxContainer/Panel/RefillAmmonition/MarginContainer/HBoxContainer/Cost
	if costumer.money >= int(ammo_cost_label.text.split(" ")[0]): 
		ammo_cost_label.set("theme_override_colors/font_color", Color(31.0/255.0, 186.0/255.0, 79.0/255.0)) 
	else:
		ammo_cost_label.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1)) 
	
	for buy_btn in shop.get_children():
		var pod_item_container = buy_btn.get_child(0).get_child(0) 
		var cost: Label = pod_item_container.get_node_or_null("Cost")
		if cost:
			if costumer.money >= int(cost.text.split(" ")[0]): 
				cost.set("theme_override_colors/font_color", Color(31.0/255.0, 186.0/255.0, 79.0/255.0)) 
			else:
				cost.set("theme_override_colors/font_color", Color(0.8, 0.1, 0.1)) 

func _on_refill_ammonition_button_pressed(cost: int) -> void:
	if costumer.money >= cost:
		costumer.money -= cost
		costumer.add_ammo()
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
	else:
		#print("Not enough money to buy that")
		return
