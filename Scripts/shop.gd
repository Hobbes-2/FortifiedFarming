extends StaticBody2D

@export var player : Player

func _ready() -> void:
	$ShopMenu.visible = false
	$SellMenu.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("player_shop_method"):
		$ShopMenu.visible = true
		$SellMenu.visible = true
		$ShopSFX.play()
func _on_area_2d_body_exited(body: Node2D) -> void:
	$ShopMenu.visible = false
	$SellMenu.visible = false
