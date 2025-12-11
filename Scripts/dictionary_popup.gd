extends Node2D

@onready var description_label: Label = $descriptionLabel
@onready var name_label: Label = $NameLabel
@onready var price_label: Label = $priceLabel
@onready var location_label: Label = $LocationLabel
@onready var icon_image: Sprite2D = $IconImage
@onready var item_dict: Control = $"../Item Dictionary"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("ts:", item_dict)
	item_dict.connect("updateDictionaryStats", update_stats)
	hide()


func _on_close_button_pressed() -> void:
	hide()

func update_stats():
	description_label.text = "Description - " + item_dict.description
	name_label.text = item_dict.descName
	price_label.text = "Price - " + str(item_dict.price)
	location_label.text = "Found - " + item_dict.location
	icon_image.texture = item_dict.icon
	print("2")
