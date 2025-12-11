extends Control

var is_open : bool = false

var inv : Inv = preload("res://Scenes/Inventory/DictionaryInventory.tres")
@onready var slots: Array = $NinePatchRect/ScrollContainer/GridContainer.get_children()
@export var camera : Camera2D
@onready var dict_popup = $"../DictionaryPopup"

var descName
var description
var price
var location
var icon

var item 
var number = 1
signal collect
signal updateDictionaryStats

func _ready() -> void:
	update_slots()
	close()
	inv.update.connect(update_slots)

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
		if inv.slots[i].item:
			descName = inv.slots[i].item.name
			description = inv.slots[i].item.definition
			price = inv.slots[i].item.price
			location = inv.slots[i].item.location
			icon = inv.slots[i].item.texture
			emit_signal("updateDictionaryStats")
			#var popup = load("res://Scenes/dictionary_popup.tscn").instantiate()
			#get_parent().add_child(popup)
			print("1")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Dictionary"):
		if is_open == false:
			open()
		else:
			close()
	global_position = camera.get_screen_center_position()

	if Input.is_action_just_pressed("Click"):
		update_slots()
		open_def()

	for j in range(get_parent().inv.slots.size()):
		if get_parent().inv.slots[j].item != null:
			item = get_parent().inv.slots[j].item
			print(item)
			collect.emit()

func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	dict_popup.hide()

func open_def():
	pass
