extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_label: Label = $CenterContainer/Panel/Label

@export var debug : bool

var hovering : bool = false

func update(slot : InvSlot):
		if slot.item == load("res://Scenes/Inventory/items/" + str(PlayerGlobals.selected_plant).to_lower().left(-1) + "Inv" + ".tres") and slot.amount <= 0:
			PlayerGlobals.selected_plant = ""
			item_display.visible = false
			amount_label.visible = false

		elif !slot.item or slot.amount <= 0:
			item_display.visible = false
			amount_label.visible = false
		else:
			item_display.visible = true
			item_display.texture = slot.item.texture
			amount_label.visible = true
			amount_label.text = str(slot.amount)
			#print("test:" + str(iawwdatem_display.texture))
		select(slot)


func select(slot):
	if debug:
		print(slot.item)
	if hovering and slot.item:
			PlayerGlobals.selected_plant = slot.item.texture.get_path().get_file()
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant.left(PlayerGlobals.selected_plant.length() - 4)
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant.to_lower()
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant + "0"
			if debug:
				print("The selected plant is:" , PlayerGlobals.selected_plant)
	#else:
		#print("Cannot select item!")

func _on_mouse_entered() -> void:
	hovering = true
	if debug:
		print("entered")
		print(PlayerGlobals.selected_plant)

func _on_mouse_exited() -> void:
	hovering = false
	if debug:
		print("exited")
