extends Panel

@onready var item_display: Sprite2D = $CenterContainer/Panel/ItemDisplay
@onready var amount_label: Label = $CenterContainer/Panel/Label

@export var debug : bool

var hovering : bool = false

#things to do with the plant dictionary
@export var dictionary : bool = false
var first_time : bool = true
var dict_popup = load("res://Scenes/dictionary_popup.tscn")
var unlocked : bool = true


func update(slot : InvSlot):
	if dictionary and first_time == false:
		if hovering == true and unlocked == true:
			get_parent().get_parent().get_parent().get_parent().dict_popup.show()
	else:
		if slot.item == load("res://Scenes/Inventory/items/" + str(PlayerGlobals.selected_plant).to_lower().left(-1) + "Inv" + ".tres") and slot.amount <= 0:
			PlayerGlobals.selected_plant = ""
			item_display.visible = false
			amount_label.visible = false
			select(slot)
		elif slot.item == load("res://Scenes/Inventory/items/" + str(PlayerGlobals.selected_plant).to_lower().left(-1) + "Inv" + ".tres") and slot.amount > 0 and hovering == true:
			PlayerGlobals.selected_plant = ""
			print("cleared")
		elif !slot.item or slot.amount <= 0:
			item_display.visible = false
			amount_label.visible = false
			select(slot)
		else:
			item_display.visible = true
			item_display.texture = slot.item.texture
			amount_label.visible = true
			amount_label.text = str(slot.amount)
			#print("test:" + str(iawwdatem_display.texture))
			select(slot)
		first_time = false


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
