extends Resource

class_name Inv

signal update

@export var slots: Array[InvSlot]

func insert(item : InvItem, amount : int):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += amount
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = amount
	update.emit()
	print("made iot")
func clear(item : InvItem):
	for i in 11:
		slots[i].item = null #take this out if the amount you want to be 1
		slots[i].amount = 0 #set to 1 to keep one when sell all
	update.emit()
