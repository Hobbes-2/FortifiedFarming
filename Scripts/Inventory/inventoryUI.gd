extends Control

var is_open : bool = false

var inv : Inv = preload("res://Scenes/Inventory/playerInv.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@export var camera : Camera2D

func _ready() -> void:
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])
		print(inv.slots[i])

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Inventory"):
		if is_open == false:
			open()
		else:
			close()
	global_position = camera.get_screen_center_position()
func open():
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
