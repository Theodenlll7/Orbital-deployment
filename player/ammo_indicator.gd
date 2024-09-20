extends HBoxContainer
class_name AmmoIndicator


@onready var magazin_ammo = $MagazineAmmo
@onready var extra_ammo = $ExtraAmmo
@onready var devider = $Devider

func equip_weapon(weapon: Weapon):
	var data : WeaponResource = weapon.weapon_resource
	if data.has_magazine:
		weapon.weapon_fired.connect(_on_magazine_changed)
		magazin_ammo.text = "%d" % data.ammo_in_magazine
		magazin_ammo.visible = true
	elif data.ammo:
		weapon.weapon_fired.connect(_on_magazine_changed)
		magazin_ammo.text = "%d" % data.ammo
		magazin_ammo.visible = true
	else:
		magazin_ammo.visible = false
	if data.has_magazine and data.has_ammo:
		weapon.weapon_reloded.connect(_on_ammo_changed)
		extra_ammo.text = "%d" % data.ammo
		devider.visible = true
		extra_ammo.visible = true
	else:
		devider.visible = false
		extra_ammo.visible = false
		

func _on_magazine_changed(new_magazine_amount : int):
	magazin_ammo.text = "%d" % new_magazine_amount
	

func _on_ammo_changed(new_magazine_amount : int,new_ammo_amount : int):
	extra_ammo.text = "%d" % new_ammo_amount
	magazin_ammo.text = "%d" % new_magazine_amount
	
