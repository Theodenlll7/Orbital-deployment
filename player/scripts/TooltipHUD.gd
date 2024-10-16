extends Node

signal show_tip(text: String)
var show_tips: bool = true

var first_time_purchase_of_weapon: bool = true
var first_time_purchase_of_explosive: bool = true
var first_time_damage: bool = true
var second_weapon_bought: bool = false
var first_wave_over: bool = false


var start_text: String = "[color=cyan]Tip: [/color]"


func init_vars() -> void:
	first_time_purchase_of_weapon = true
	first_time_damage = true
	second_weapon_bought = false
	first_wave_over = false
	
	
func set_tooltip_HUD_text(text: String) -> void:
	if !show_tips: return
	show_tip.emit(start_text + text)

func show_wepon_tip() -> void:
	if !first_time_purchase_of_weapon: return
	first_time_purchase_of_weapon = false
	second_weapon_bought = true
	
	var swap_wepon_key: String = get_key("swap_weapon") 
	var text: String = "Ready to unleash chaos? Press [color=green]" + swap_wepon_key + "[/color] to swap to your brand-new weapon."
	set_tooltip_HUD_text(text)
	
func show_dodge_tip() -> void:
	if !first_time_damage: return
	first_time_damage = false
	var dodge_key: String = get_key("dodge") 
	var text = "You've been hit! Quick, press [color=green]" + dodge_key + "[/color] to dodge and weave out of your enemies' clutches!"
	set_tooltip_HUD_text(text)

func show_diffrent_wepons_tips() -> void:
	if !second_weapon_bought: return
	second_weapon_bought = false
	
	var text = "Heavy-duty firepower! A variety of weapon, choose the right one for the job!"
	set_tooltip_HUD_text(text)

func show_explosive_tip() -> void:
	if !first_time_purchase_of_explosive: return
	first_time_purchase_of_explosive = false
	
	var swap_wepon_key: String = get_key("throw_action") 
	var text: String = "Ready to wreak havoc? Press [color=green]" +  swap_wepon_key + "[/color] to toss a grenade!"
	set_tooltip_HUD_text(text)
	pass

func show_first_wave_over_tip() -> void:
	var text: String = "Wave over! If you've got some credits [color=green]$[/color], now's the time to spend them!"
	set_tooltip_HUD_text(text)

func get_key(key: String) -> String:
	var action_events = InputMap.action_get_events(key)
	var action_event = action_events[0]
	
	if action_event is InputEventKey:
		var action_key_code = OS.get_keycode_string(action_event.physical_keycode)
		return "%s" % action_key_code
	
	elif action_event is InputEventMouseButton:
		var mouse_button_index = action_event.button_index		
		match mouse_button_index:
			MOUSE_BUTTON_LEFT:
				return "Left Mouse Button"
			MOUSE_BUTTON_RIGHT:
				return "Right Mouse Button"
			MOUSE_BUTTON_MIDDLE:
				return "Middle Mouse Button"
			MOUSE_BUTTON_WHEEL_UP:
				return "Wheel Up Mouse Button"
			MOUSE_BUTTON_WHEEL_DOWN:
				return "Wheel Down Mouse Button"
			MOUSE_BUTTON_WHEEL_LEFT:
				return "Wheel Left Mouse Button"
			MOUSE_BUTTON_WHEEL_RIGHT:
				return "Wheel Right Mouse Button"
			_:
				return "Mouse Button: Unknown"

	return "Unknown input event type."
