extends Control

@export var weapon_buy_button : PackedScene

@export var weapons_dir: String = "res://inventory/items/weapons/weapon_types/"

var weapons : Array[Weapon] = []

func _ready():
	var weapon_data = load_all_resources(weapons_dir)
	for data in weapon_data:
		if data is ProjectileWeaponData:
				weapons.append(ProjectileWeapon2D.new(data))
		elif data is WeaponData:
				weapons.append(Weapon.new(data))

	print(weapons)
	setLabelsAndCost()
	updateButtonLabels()
	

func setLabelsAndCost():
	var shop = $Weapon_paths/ScrollContainer/shop
	var counter = 0
	for weapon in weapons:
		var buy_btn = weapon_buy_button.instantiate()
		var label : Label = buy_btn.get_node_or_null("Label")
		var cost : Label = buy_btn.get_node_or_null("Cost")
		label.text = weapon.weapon_data.weapon_name
		cost.text = "%d $" % weapon.weapon_data.weapon_cost
		shop.add_child(buy_btn)
		
				
func updateButtonLabels():
	var player_money = $Header.get_node("Players_money")
	player_money.text = str(GameVariables.player_money) + "$"

func _on_pistols_button_pressed() -> void:
	var weaponsUI = $weapons_UI
	weaponsUI.hide()
	var weapon_node_tree = $Weapon_paths
	weapon_node_tree.show()
	print("test")

func getWeaponUI(value):
	var weapon_node_tree = $Weapon_paths
	weapon_node_tree.show()
	return weapon_node_tree.get_child(value-1)

func showCorrectWeaponUI(not_to_hide):
	var weapon_node_tree = $Weapon_paths
	for i in range(weapon_node_tree.get_child_count()):
		var child = weapon_node_tree.get_child(i)
		child.hide()  
	not_to_hide.show()
	$Weapon_paths/back_button.show()
	$Weapon_paths/back_button/Label.show()

func _on_back_button_pressed() -> void:
	var weapon_node_tree = $Weapon_paths
	weapon_node_tree.hide()
	var weaponsUI = $weapons_UI
	weaponsUI.show()


func _on_button_pressed(extra_arg_1: int) -> void:
	var weapon = PodVariables.weapons[extra_arg_1]
	var type =PodVariables.weapons[extra_arg_1].weapon_name
	var cost = PodVariables.weapons[extra_arg_1].weapon_cost
	Shop.handleBuy(type, cost, weapon)
	updateButtonLabels()
	
func load_all_resources(folder_path: String) -> Array:
	var dir = DirAccess.open(folder_path)
	var resources = []
	
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
