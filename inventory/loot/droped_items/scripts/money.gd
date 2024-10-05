class_name MoneyItem extends Item

@export var money_amount: int = 25


func pickup_item(player: Player) -> void:
	player.inventory.money += money_amount
