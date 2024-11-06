extends Control

const CREDITS_PATH = "res://data/credits.json"

# Color and font settings for display (customize as needed)
@export var credit_item: CreaditItem
@export var url_button_scene: PackedScene # Optional custom URLButton scene for links

func _ready():
	# Load and parse the JSON file
	var credits_data = load_credits()
	if credits_data:
		display_credits(credits_data)
	else:
		print("Failed to load credits data.")

# Function to load JSON file and parse credits
func load_credits() -> Array:
	var file = FileAccess.open(CREDITS_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
		
	if typeof(data) == TYPE_DICTIONARY and data.has("credits"):
		return data["credits"]
	else:
		print("Credits file not found.")
		return []

# Function to display credits on screen by category
func display_credits(credits_data: Array) -> void:
	for category in credits_data:
		if category.has("category") and category.has("members"):
			# Add category label
			var category_label = Label.new()
			category_label.text = category["category"]
			#category_label.theme.font_color = category_color
			add_child(category_label)
			
			# Display each member under the category
			for member in category["members"]:
				add_member(member)

# Function to add a member's name, role, and optional URL button
func add_member(member: Dictionary) -> void:
	var name_label = Label.new()
	name_label.text = member["name"]
	#name_label.theme.font_color = name_color
	add_child(name_label)
	
	var role_label = Label.new()
	role_label.text = member["role"]
	#role_label.theme.font_color = role_color
	add_child(role_label)
	
	# Add URL button if URL is present
	if member.has("url") and member["url"] != "":
		add_url_button(member["url"])

# Function to add a URLButton for the provided URL
func add_url_button(url: String) -> void:
	if url_button_scene:
		# Use a custom URLButton scene if provided
		var url_button = url_button_scene.instance()
		url_button.set("url", url)  # Assuming `url` is a property in custom URLButton scene
		add_child(url_button)
	else:
		# Default: Create a simple URLButton
		var button = URLButton.new(url)
		button.text = "Link"
		add_child(button)

# Callback function to open URL when button is pressed
func _on_url_button_pressed(url: String) -> void:
	OS.shell_open(url)
