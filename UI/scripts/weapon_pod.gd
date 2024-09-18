extends Control

@export var weapon_buy_button: PackedScene

@export var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"

var weapons: Array[WeaponResource] = []


func _ready():
	weapons = load_all_resources(weapons_dir)

	setLabelsAndCost()
	updateButtonLabels()


func setLabelsAndCost():
	var shop = $ScrollContainer/shop
	for weapon in weapons:
		var buy_btn: Button = weapon_buy_button.instantiate()
		var label: Label = buy_btn.get_node_or_null("Label")
		var cost: Label = buy_btn.get_node_or_null("Cost")
		label.text = weapon.weapon_name
		cost.text = "%d $" % weapon.weapon_cost
		buy_btn.action_mode = BaseButton.ACTION_MODE_BUTTON_RELEASE
		buy_btn.connect("pressed", _on_button_pressed.bind(weapon.weapon_name))
		shop.add_child(buy_btn)


func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.player_money) + "$"


func _on_button_pressed(identifier: StringName) -> void:
	var weapon := find_weapon(identifier)
	var type = weapon.weapon_name
	var cost = weapon.weapon_cost
	Shop.handleBuy(type, cost, weapon)
	updateButtonLabels()


func find_weapon(identifier: StringName) -> WeaponResource:
	for weapon in weapons:
		if weapon.weapon_name == identifier:
			return weapon
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
				var resource = ResourceLoader.load(file_path)
				if resource:
					resources.append(resource)

			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Failed to open folder: " + folder_path)

	return resources
