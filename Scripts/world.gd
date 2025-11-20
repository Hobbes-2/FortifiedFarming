extends Node2D

@export var ground_tilemap : TileMapLayer
@export var seed_tilemap : TileMapLayer

var can_place_seed = "can_place_seed"

var ground_layer = 1

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
		var source_id = 0
		var tile_to_be_placed = Vector2i(2, 2)
		
		var tiledata = ground_tilemap.get_cell_tile_data(tile_mouse_pos)
		var level : int = 0
		var final_seed_level : int = 2
		if tiledata:
			var placeable = tiledata.get_custom_data(can_place_seed)
			if placeable:
				seed_handling(tile_mouse_pos, level, tile_to_be_placed, final_seed_level)
			else:
				print("cannot place here")
		else:
			print("no tiledata")

func seed_handling(tilemap_pos, level, atlas_coords, final_seed_level):
	var source_id = 0
	seed_tilemap.set_cell(tilemap_pos, source_id, atlas_coords)

	await get_tree().create_timer(10.0).timeout

	if level == final_seed_level:
		return
	else:
		var new_atlas : Vector2i = Vector2i(atlas_coords.x + 2, atlas_coords.y)
		seed_handling(tilemap_pos, level + 1, new_atlas, final_seed_level)
