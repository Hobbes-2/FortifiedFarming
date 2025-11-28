extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_label: Label = $CenterContainer/Panel/Label

var hovering : bool = false

func update(slot : InvSlot):
	if !slot.item:
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
	print(slot.item)
	if hovering and slot.item:
			PlayerGlobals.selected_plant = slot.item.texture.get_path().get_file()
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant.remove_chars(".png")
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant.to_lower()
			PlayerGlobals.selected_plant = PlayerGlobals.selected_plant + "0"
			print("The selected plant is:" , PlayerGlobals.selected_plant)
	#else:
		#print("Cannot select item!")

func _on_mouse_entered() -> void:
	hovering = true
	print("entered")
	print(PlayerGlobals.selected_plant)

func _on_mouse_exited() -> void:
	hovering = false
	print("exited")
