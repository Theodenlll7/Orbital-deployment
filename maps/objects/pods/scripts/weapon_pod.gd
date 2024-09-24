extends Control

@export var weapon_buy_button: PackedScene

@export var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"
@export var explosive_dir: String = "res://inventory/items/explosives/explosive_types/"

var weapons: Array[WeaponResource] = []
var explosives: Array[ExplosiveResource] = []

var podType: String = ""
func _ready():
	updateButtonLabels()

func loadResource(type):
	podType = type
	match type:
		"weapon":
			weapons = load_all_resources(weapons_dir)
			return weapons
		"explosive":
			explosives = load_all_resources_explosive(explosive_dir)
			return explosives
	
func setLabelsAndCost(array_items):
	var shop = $ContentPanelContainer/MarginContainer/ScrollContainer/shop
	for item in array_items:
		var buy_btn: Button = weapon_buy_button.instantiate()
		var pod_item_container = buy_btn.get_child(0)
		var label: Label = pod_item_container.get_node_or_null("Label")
		var cost: Label = pod_item_container.get_node_or_null("Cost")
		label.text = item.item_name
		cost.text = "%d $" % item.cost
		buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
		buy_btn.connect("pressed", _on_button_pressed.bind(item.item_name))
		shop.add_child(buy_btn)

func updateButtonLabels():
	var player_money = $HeaderPanelContainer/MarginContainer/HBoxContainer.get_node("Players_money")
	player_money.text = str(GameVariables.player_money) + "$"


func _on_button_pressed(identifier: StringName) -> void:
	var item = find_item(identifier)
	var cost = item.cost
	Shop.handleBuy(item.duplicate(), cost)
	updateButtonLabels()

func find_item(identifier: StringName):
	match podType:
		"explosive":
			return find_explosive(identifier)
		"weapon":
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

func load_all_resources(folder_path: String) -> Array[WeaponResource]:
	var dir = DirAccess.open(folder_path)
	var resources: Array[WeaponResource] = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				# Skip directories for now, or handle them recursively if needed
				pass
			elif file_name.ends_with(".tres"):
				var file_path = folder_path + file_name
				print(file_path)
				var resource = ResourceLoader.load(file_path)
				if resource:
					resources.append(resource)

			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Failed to open folder: " + folder_path)

	return resources

func load_all_resources_explosive(folder_path: String) -> Array[ExplosiveResource]:
	var dir = DirAccess.open(folder_path)
	var resources: Array[ExplosiveResource] = []

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if dir.current_is_dir():
				# Skip directories for now, or handle them recursively if needed
				pass
			elif file_name.ends_with(".tres"):
				var file_path = folder_path + file_name
				print(file_path)
				var resource = ResourceLoader.load(file_path)
				if resource:
					resources.append(resource)

			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Failed to open folder: " + folder_path)

	return resources
