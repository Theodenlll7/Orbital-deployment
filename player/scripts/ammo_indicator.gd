extends HBoxContainer
class_name AmmoIndicator

@onready var magazin_ammo = $MagazineAmmo
@onready var extra_ammo = $ExtraAmmo
@onready var devider = $Control/Devider


func equip_weapon(weapon: WeaponResource):
	reset_indicators()

	if weapon.has_magazine:
		# Show magazine ammo count
		magazin_ammo.text = "%d" % weapon.ammo_in_magazine
		magazin_ammo.visible = true
		if !weapon.magazine_changed.is_connected(_on_magazine_changed):
			weapon.magazine_changed.connect(_on_magazine_changed)

		extra_ammo.visible = true
		devider.visible = true

		if weapon.has_ammo:
			extra_ammo.text = "%d" % weapon.ammo
			if !weapon.ammo_changed.is_connected(_on_ammo_changed):
				weapon.ammo_changed.connect(_on_ammo_changed)
		else:
			# No extra ammo, show infinity for extra ammo
			extra_ammo.text = "Ꝏ"
	else:
		# If no magazine, show ammo only
		magazin_ammo.text = "%d" % weapon.ammo
		magazin_ammo.visible = true
		if !weapon.ammo_changed.is_connected(_on_magazine_changed):
			weapon.ammo_changed.connect(_on_magazine_changed)


func reset_indicators():
	magazin_ammo.visible = false
	extra_ammo.visible = false
	devider.visible = false


func _on_magazine_changed(new_magazine_amount: int):
	magazin_ammo.text = "%d" % new_magazine_amount


func _on_ammo_changed(new_ammo_amount: int):
	extra_ammo.text = "%d" % new_ammo_amount
