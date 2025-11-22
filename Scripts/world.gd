extends Node2D

@export var ground_tilemap : TileMapLayer
@export var seed_tilemap : TileMapLayer
@export var player : Player

var plant_name_list : Array = ["Carrot"]
var plant_scene_list : Array = ["res://Scenes/test_crop.tscn"]
var plant_inv_list : Array  = []#= ["res://images/Plants/" + plant_name_list + "Inv" + ".png"]

var plant_dict : Dictionary = {}

var can_place_seed = "can_place_seed"
var plant_placed = "placed"
var ground_layer = 1
"res://Scenes/Inventory/items/carrotInv.tres"

func _ready() -> void:
	for i in plant_name_list.size():
		plant_inv_list.append("res://Scenes/Inventory/items/" + (plant_name_list[i]).to_lower() + "Inv" + ".tres") #= 
		plant_dict.set(plant_name_list[i], plant_inv_list[i]) # plant_name_list[i]
	print(plant_dict)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)

		var tile_to_be_placed = Vector2i(2, 2)
		
		var tiledata = ground_tilemap.get_cell_tile_data(tile_mouse_pos)
		var tiledata2 = seed_tilemap.get_cell_tile_data(tile_mouse_pos)
		var level : int = 0
		var final_seed_level : int = 2
		if tiledata:
			var placeable = tiledata.get_custom_data(can_place_seed)
			var already_placed = false
			if tiledata2:
				already_placed = tiledata2.get_custom_data(plant_placed)
				print(tiledata2.get_custom_data(name))
			if placeable and already_placed == false:
				seed_handling(tile_mouse_pos, level, tile_to_be_placed, final_seed_level)
				if tiledata2:
					tiledata2.set_custom_data(plant_placed, true)
			else:
				print("cannot place here")
		else:
			print("no tiledata")

	if Input.is_action_just_pressed("Harvest"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
		var tiledata2 = seed_tilemap.get_cell_tile_data(tile_mouse_pos)

		if tiledata2:
			print("its:" + str(tiledata2.get_custom_data("name")))
			if tiledata2.get_custom_data("harvestable") and plant_dict[tiledata2.get_custom_data("name")] != null:
				var item = load(plant_dict[tiledata2.get_custom_data("name")])
				seed_tilemap.set_cell(tile_mouse_pos, 0, Vector2i(8, 8))
				#harvest()
				player.collect(item)
			else:
				print("cannot harvest")


func seed_handling(tilemap_pos, level, atlas_coords, final_seed_level):
	var source_id = 0

	seed_tilemap.set_cell(tilemap_pos, source_id, atlas_coords)

	await get_tree().create_timer(5.0).timeout

	if level == final_seed_level:
		pass
	else:
		var new_atlas : Vector2i = Vector2i(atlas_coords.x + 2, atlas_coords.y)
		seed_handling(tilemap_pos, level + 1, new_atlas, final_seed_level)

func harvest(item):
	player.collect(item)
