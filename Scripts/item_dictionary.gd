extends Control

var is_open : bool = false

var inv : Inv = preload("res://Scenes/Inventory/DictionaryInventory.tres")
@onready var slots: Array = $NinePatchRect/ScrollContainer/GridContainer.get_children()
@export var camera : Camera2D
@onready var dict_popup = $"../DictionaryPopup"
func _ready() -> void:
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

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


func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
	dict_popup.hide()

func open_def():
	pass
