extends HBoxContainer
class_name AmmoIndicator

@onready var magazin_ammo = $MagazineAmmo
@onready var extra_ammo = $ExtraAmmo
@onready var devider = $Control/Devider


func equip_weapon(weapon: WeaponResource):
	weapon.ammo_changed.connect(_on_ammo_changed)
	weapon.magazine_changed.connect(_on_magazine_changed)
	if weapon.has_magazine:
		magazin_ammo.text = "%d" % weapon.ammo_in_magazine
		magazin_ammo.visible = true
		if !weapon.has_ammo:
			devider.visible = true
			extra_ammo.visible = true
			extra_ammo.text = "∞"
	elif weapon.ammo:
		magazin_ammo.text = "%d" % weapon.ammo
		magazin_ammo.visible = true
	else:
		magazin_ammo.visible = false
	if weapon.has_magazine and weapon.has_ammo:
		extra_ammo.text = "%d" % weapon.ammo
		devider.visible = true
		extra_ammo.visible = true


func _on_magazine_changed(new_magazine_amount: int):
	magazin_ammo.text = "%d" % new_magazine_amount


func _on_ammo_changed(new_ammo_amount: int):
	extra_ammo.text = "%d" % new_ammo_amount
