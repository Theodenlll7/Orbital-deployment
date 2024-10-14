extends Node

signal show_tip(text: String)
var show_tips: bool = true

var first_time_purchase_of_weapon: bool = true
var first_time_damage: bool = true
var second_weapon_bought: bool = false

var start_text: String = "[color=cyan]Tip: [/color]"


func init_vars() -> void:
	first_time_purchase_of_weapon = true
	first_time_damage = true
	second_weapon_bought = false
	
	
func set_tooltip_HUD_text(text: String) -> void:
	if !show_tips: return
	show_tip.emit(start_text + text)

func show_wepon_tip() -> void:
	if !first_time_purchase_of_weapon: return
	first_time_purchase_of_weapon = false
	second_weapon_bought = true
	
	var swap_wepon_key: String = get_key("swap_weapon") 
	var text: String = "Ready to unleash chaos? Press [color=green]" + swap_wepon_key + "[/color] to swap to your brand-new weapon and feel the power surge through your hands."
	set_tooltip_HUD_text(text)
	
func show_dodge_tip() -> void:
	if !first_time_damage: return
	first_time_damage = false
	var dodge_key: String = get_key("dodge") 
	var text = "Ouch! You've been hit! Quick, press [color=green]" + dodge_key + "[/color] to dodge and weave out of your enemies' clutches. Stay nimble, stay alive!"
	set_tooltip_HUD_text(text)

func show_diffrent_wepons_tips() -> void:
	if !second_weapon_bought: return
	second_weapon_bought = false
	
	var text = "Heavy-duty firepower! Snipers for precision, shotguns for close blasts, and assault rifles for all-around mayhem. Pick your weapon, rule the fight!"
	set_tooltip_HUD_text(text)


func get_key(key: String) -> String:
	var action_events = InputMap.action_get_events(key)
	var action_event = action_events[0]
	var action_key_kode = OS.get_keycode_string(action_event.physical_keycode)
	return "%s" % action_key_kode
