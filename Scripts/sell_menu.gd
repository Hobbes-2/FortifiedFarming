extends StaticBody2D

var player 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().player
	self.visible = false

func _physics_process(delta: float) -> void:
	$TotalPrice.text = str(PlayerGlobals.sell_total)


func _on_sell_pressed() -> void:
	PlayerGlobals.money += PlayerGlobals.sell_total
	PlayerGlobals.sell_total = 0
	for i in range(1, 12):
		player.clear(player.inv.slots[i].item)
