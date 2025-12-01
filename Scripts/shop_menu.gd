extends StaticBody2D

var item = 1
var number_of_items 

var item_price = 100
var item_owned = false

var price
var player

var list : Dictionary = {
	"1" : "res://Scenes/Inventory/items/peapodInv.tres",
	"2" : "res://Scenes/Inventory/items/melonInv.tres",
	"3" : "res://Scenes/Inventory/items/caneInv.tres",
	"4" : "res://Scenes/Inventory/items/squashInv.tres"}


func _ready() -> void:
	number_of_items = list.size()
	player = get_parent().player
	$Icon.play("1")
	item = 1

func _physics_process(delta: float) -> void:
	if self.visible == true:
		pass
	$Icon.play(str(item))
	$Price.text = str(item_price)

func _on_left_button_pressed() -> void:
	swap_item_back()


func _on_right_button_pressed() -> void:
	swap_item_forward()


func _on_buy_pressed() -> void:
	price = item_price
	if PlayerGlobals.money >= price:
		buy()

func swap_item_back():
	if item:
		item += 1
	if item > number_of_items:
		item = 1

func swap_item_forward():
	if item:
		item -= 1
	if item == 0:
		item = number_of_items

func buy():
	PlayerGlobals.money -= price
	player.collect(load(list[str(item)]), 1)
