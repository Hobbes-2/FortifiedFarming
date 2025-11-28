extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_label: Label = $CenterContainer/Panel/Label

var hovering : bool = false
var selected_plant = ""

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
			selected_plant = slot.item.texture
			print(selected_plant)
	else:
		print("Cannot select item!")

func _on_mouse_entered() -> void:
	hovering = true
	print("entered")
	print(selected_plant)

func _on_mouse_exited() -> void:
	hovering = false
	print("exited")
