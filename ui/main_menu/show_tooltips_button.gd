extends Control
@onready var toggle_button: Button = $HBoxContainer/ToggleButton
var show_tooltips: bool

func _ready() -> void:
	show_tooltips = TooltipHud.show_tips
	handle_connecting_signals()

func on_tooltips_togled() -> void:
	show_tooltips = !show_tooltips
	if show_tooltips:
		toggle_button.text = " On  "
		TooltipHud.show_tips = true
		TooltipHud.init_vars()
	else:
		toggle_button.text = " Off "
		TooltipHud.show_tips = false

func handle_connecting_signals() -> void:
	toggle_button.button_down.connect(on_tooltips_togled)
