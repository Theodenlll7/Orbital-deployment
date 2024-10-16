class_name ExplosiveContainer extends HBoxContainer

@onready var label := $MarginContainer/Label
@onready var icon := $AspectRatioContainer2/AspectRatioContainer/Icon

func _count_changed(count : int) -> void:
	label.text = str(count)

func set_icon(texture : Texture2D) -> void:
	icon.texture = texture
