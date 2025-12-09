extends Node2D

@export var ground_tilemap : TileMapLayer
@export var seed_tilemap : TileMapLayer
@export var player : Player
@export var debug : bool
var plant_name_list : Array = ["Peapod", "Melon", "Cane", "Squash", "Bed"]
var plant_scene_list : Array = ["res://Scenes/test_crop.tscn"]
var plant_inv_list : Array  = []#= ["res://images/Plants/" + plant_name_list + "Inv" + ".png"]

var plant_dict : Dictionary = {}

var can_place_seed = "can_place_seed"
var plant_placed = "placed"
var ground_layer = 1
"res://Scenes/Inventory/items/carrotInv.tres"

#saving stuff
var savepath = "user://game.save"
var savepathRESET = "user://reset.save"

#scene transition
var interacting : bool = false
var inside : bool = false
@onready var scene_transition_anim: AnimationPlayer = $AllMoving/SceneTransitionAnim/AnimationPlayer

func _ready() -> void:
	for i in plant_name_list.size():
		plant_inv_list.append("res://Scenes/Inventory/items/" + (plant_name_list[i]).to_lower() + "Inv" + ".tres") #= 
		plant_dict.set(plant_name_list[i].to_lower() + "0", plant_inv_list[i]) # plant_name_list[i]
	print(plant_dict)
	saveRESET()
	load_data()
	scene_transition_anim.get_parent().get_node("ColorRect").visible = true
	scene_transition_anim.get_parent().get_node("ColorRect").color.a = 255
	scene_transition_anim.play("FadeOut")
	await get_tree().create_timer(0.5).timeout
	scene_transition_anim.get_parent().get_node("ColorRect").visible = false

func _physics_process(delta: float) -> void:

	#for i in $AllMoving.get_child_count():
	#$AllMoving.global_position.x += 0.1


	if Input.is_action_pressed("Interact"):
		if inside:
			scene_transition_anim.get_parent().get_node("ColorRect").visible = true
			scene_transition_anim.play("FadeIn")
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file("res://Scenes/room.tscn")
			save()

#green highlight for tiles for placing beds



	if PlayerGlobals.selected_plant == "bed0":
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
		var tiledata = ground_tilemap.get_cell_tile_data(tile_mouse_pos)
		var tile_mouse_posGND = ground_tilemap.local_to_map(mouse_pos)

		var tileset := ground_tilemap.tile_set
		for i in range(tileset.get_source_count()):
			var source_id := tileset.get_source_id(i)
			var source := tileset.get_source(source_id)
			if source is TileSetAtlasSource:
				var atlas_source := source as TileSetAtlasSource
				var atlas_size := atlas_source.get_atlas_grid_size()
				for x in range(atlas_size.x):
					for y in range(atlas_size.y):
						var coords := Vector2i(y, x)
						if atlas_source.has_tile(coords):
							var data = atlas_source.get_tile_data(coords, 0) # 0 = default alternative
							if data:
								if data.material:
									data.material.set_shader_parameter('intensity', 0.3)
									#if data == tiledata:
										#tileset.get_cell_tile_data(coords).material.set_shader_parameter('intensity', 0.6)
									if Vector2i(roundi(mouse_pos.x), roundi(mouse_pos.y)) == coords:
										data.material.set_shader_parameter('intensity', 0.6)


	else:
		var tileset := ground_tilemap.tile_set
		for i in range(tileset.get_source_count()):
			var source_id := tileset.get_source_id(i)
			var source := tileset.get_source(source_id)
			if source is TileSetAtlasSource:
				var atlas_source := source as TileSetAtlasSource
				var atlas_size := atlas_source.get_atlas_grid_size()
				for x in range(atlas_size.x):
					for y in range(atlas_size.y):
						var coords := Vector2i(y, x)
						if atlas_source.has_tile(coords):
							var data = atlas_source.get_tile_data(coords, 0) # 0 = default alternative
							if data:
								if data.material:
									data.material.set_shader_parameter('intensity', 0.0)


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("Click"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
		var tile_mouse_posGND = ground_tilemap.local_to_map(mouse_pos)

		var tile_to_be_placed = Vector2i(9, 9)
		var tiledata = ground_tilemap.get_cell_tile_data(tile_mouse_pos)
		var tiledata2 = seed_tilemap.get_cell_tile_data(tile_mouse_pos)
		var level : int = 0
		var final_seed_level : int = 2

		var shift_tiledata = ground_tilemap.get_cell_tile_data(Vector2i(tile_mouse_pos.x + 1, tile_mouse_pos.y))

		if PlayerGlobals.selected_plant == "bed0":
			if shift_tiledata and tiledata:
				if tiledata.get_custom_data("can_build") == true and shift_tiledata.get_custom_data("can_build") == true :
					build(tile_mouse_posGND, Vector2i(4, 1))
					build(Vector2i(tile_mouse_posGND.x + 1, tile_mouse_posGND.y), Vector2i(5, 1))
					player.collect(load(plant_dict[PlayerGlobals.selected_plant]), -1)

		if tiledata:
			var placeable = tiledata.get_custom_data(can_place_seed)
			var already_placed = false
			if tiledata2:
				already_placed = tiledata2.get_custom_data(plant_placed)


			var tileset := seed_tilemap.tile_set
			for i in range(tileset.get_source_count()):
				var source_id := tileset.get_source_id(i)
				var source := tileset.get_source(source_id)
				if source is TileSetAtlasSource:
					var atlas_source := source as TileSetAtlasSource
					var atlas_size := atlas_source.get_atlas_grid_size()
					for x in range(atlas_size.x):
						for y in range(atlas_size.y):
							var coords := Vector2i(y, x)
							if atlas_source.has_tile(coords):
								var data = atlas_source.get_tile_data(coords, 0) # 0 = default alternative
								if data:
									var name1 = data.get_custom_data("name")
									if debug:
										print("Tile ", coords, " → name: ", name1)
									if name1 == PlayerGlobals.selected_plant:
										tile_to_be_placed = coords
										if debug:
											print("Placing:" , name1)
										#data.material.set_shader_parameter("positionz", tile_mouse_pos)

			if placeable and already_placed == false:
				
				seed_handling(tile_mouse_pos, level, tile_to_be_placed, final_seed_level)
				if tiledata2:
					tiledata2.set_custom_data(plant_placed, true)
					PlayerGlobals.sell_total -= tiledata2.get_custom_data("price")
				if PlayerGlobals.selected_plant != "" and PlayerGlobals.selected_plant != "bed0":
					player.collect(load(plant_dict[PlayerGlobals.selected_plant]), -1)

			else:
				if debug:
					print("cannot place here")
		else:
			if debug:
				print("no tiledata")

	if Input.is_action_pressed("Harvest"):
		var mouse_pos = get_global_mouse_position()
		var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
		var tiledata2 = seed_tilemap.get_cell_tile_data(tile_mouse_pos)

		if tiledata2:
			if debug:
				print("its:" + str(tiledata2.get_custom_data("name")))
			if tiledata2.get_custom_data("harvestable") and plant_dict[tiledata2.get_custom_data("name") + "0"] != null:
				var item = load(plant_dict[tiledata2.get_custom_data("name") + "0"])
				seed_tilemap.set_cell(tile_mouse_pos, 0, Vector2i(-1, -1))
				player.collect(item, randi_range(1, 3))
				PlayerGlobals.sell_total += tiledata2.get_custom_data("price")

			else:
				if debug:
					print("cannot harvest")


func seed_handling(tilemap_pos, level, atlas_coords, final_seed_level):
	var source_id = 0

	seed_tilemap.set_cell(tilemap_pos, source_id, atlas_coords)
	#seed_tilemap.get_cell_tile_data(tilemap_pos).instantiate()


	await get_tree().create_timer(5.0 +- randf_range(0, 2)).timeout

	if level == final_seed_level:
		pass
	else:
		var new_atlas : Vector2i = Vector2i(atlas_coords.x + 1, atlas_coords.y)
		seed_handling(tilemap_pos, level + 1, new_atlas, final_seed_level)

func seed_handlingALT(tilemap_pos, level, atlas_coords, final_seed_level):

	await get_tree().create_timer(5.0 +- randf_range(0, 2)).timeout

	if level == final_seed_level:
		pass
	else:
		var new_atlas : Vector2i = Vector2i(atlas_coords.x + 1, atlas_coords.y)
		seed_handling(tilemap_pos, level + 1, new_atlas, final_seed_level)

func build(pos, atlas_coords):
	var source_id = 1
	var alt_tile = 0
	ground_tilemap.set_cell(pos, source_id, atlas_coords, alt_tile)
	print(atlas_coords)

func harvest(item):
	var mouse_pos = get_global_mouse_position()
	var tile_mouse_pos = seed_tilemap.local_to_map(mouse_pos)
	var tiledata2 = seed_tilemap.get_cell_tile_data(tile_mouse_pos)
	player.collect(item, 2)
	PlayerGlobals.sell_total += tiledata2.get_custom_data("price")

func clear_inv(item):
	player.clear(item)

func _on_save_pressed() -> void:
	save()

func _on_load_pressed() -> void:
	load_data()

func save():
	var file = FileAccess.open(savepath, FileAccess.WRITE)
	
	# Save player data
	file.store_var(PlayerGlobals.selected_plant)
	file.store_var(PlayerGlobals.money)
	for i in 11:
		file.store_var(player.inv.slots[i].amount)
	file.store_var(player.global_position)
	
	# Save TileMap data
	var tilemap = $AllMoving/Tilemaps/SeedTilemap
	var used = tilemap.get_used_cells()
	var tile_data := []



	for cell in used:
		var source_id = tilemap.get_cell_source_id(cell)
		var atlas = tilemap.get_cell_atlas_coords(cell)
		var alt = tilemap.get_cell_alternative_tile(cell)
		#var level = tilemap.get_custom_data()
		var test = tilemap.local_to_map(tilemap.to_local(Vector2i(cell.x, cell.y - 16)))
		#print(tilemap.to_local(Vector2i(cell.x, cell.y - 16)))
		var tileset = tilemap.tile_set
		#var tile_cell_data = tilemap.get_cell_tile_data(test)
		#var level = tile_cell_data.get_custom_data("level")
		#var tile_data_entry = tileset.get_tile_data(source_id)

		tile_data.append({
			"pos": cell,
			"source": source_id,
			"atlas": atlas,
			"alt": alt,
			#"level": level
		})
		#print(tile_data)
	# Store the tile data
	file.store_var(tile_data)
	var gnd_tilemap = $AllMoving/Tilemaps/GroundTilemap
	var gnd_used = gnd_tilemap.get_used_cells()
	var gnd_tile_data := []
	for cell in gnd_used:
		var source_id = gnd_tilemap.get_cell_source_id(cell)
		var atlas = gnd_tilemap.get_cell_atlas_coords(cell)
		var alt = gnd_tilemap.get_cell_alternative_tile(cell)
		#var level = tilemap.get_custom_data()
		var test = gnd_tilemap.local_to_map(gnd_tilemap.to_local(Vector2i(cell.x, cell.y)))
		#print(gnd_tilemap.to_local(Vector2i(cell.x, cell.y)))
		var tileset = gnd_tilemap.tile_set
		#var tile_cell_data = tilemap.get_cell_tile_data(test)
		#var level = tile_cell_data.get_custom_data("level")
		#var tile_data_entry = tileset.get_tile_data(source_id)


		gnd_tile_data.append({
			"pos": cell,
			"source": source_id,
			"atlas": atlas,
			"alt": alt,
			#"level": level
		})


	file.store_var(gnd_tile_data)

	file.close()

func load_data():
	if FileAccess.file_exists(savepath):
		var file = FileAccess.open(savepath, FileAccess.READ)
		
		# Load player data
		PlayerGlobals.selected_plant = file.get_var()
		PlayerGlobals.money = file.get_var()
		for i in 11:
			player.inv.slots[i].amount = file.get_var()
		player.global_position = file.get_var()
		
		# Load tilemap
		var tilemap = $AllMoving/Tilemaps/SeedTilemap
		var gnd_tilemap = $AllMoving/Tilemaps/GroundTilemap
		# Place tiles back on
		tilemap.clear()  # clear existing tiles
		#gnd_tilemap.clear()

		var tile_data = file.get_var()
		var gnd_tile_data = file.get_var()

		for tile_info in tile_data:
			tilemap.set_cell(
				tile_info["pos"], 
				tile_info["source"], 
				tile_info["atlas"], 
				tile_info["alt"],
			)
			#var lev = (tile_info["level"])
			#print(tile_info["level"])
			#seed_handlingALT(tile_info["pos"], lev, tile_info["atlas"], 2)



		for gnd_tile_info in gnd_tile_data:
			gnd_tilemap.set_cell(
				gnd_tile_info["pos"], 
				gnd_tile_info["source"], 
				gnd_tile_info["atlas"], 
				gnd_tile_info["alt"],
			)

		file.close() #apparently this helps
		emit_signal("update")
	else:
		print("No data saved!")

func _on_room_detect_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		inside = true

func saveRESET():
	var file = FileAccess.open(savepathRESET, FileAccess.WRITE)
	
	# Save player data
	file.store_var(PlayerGlobals.selected_plant)
	file.store_var(PlayerGlobals.money)
	for i in 11:
		file.store_var(player.inv.slots[i].amount)
	file.store_var(player.global_position)
	
	# Save TileMap data
	var tilemap = $AllMoving/Tilemaps/SeedTilemap
	var used = tilemap.get_used_cells()
	var tile_data := []

	for cell in used:
		var source_id = tilemap.get_cell_source_id(cell)
		var atlas = tilemap.get_cell_atlas_coords(cell)
		var alt = tilemap.get_cell_alternative_tile(cell)
		#var level = tilemap.get_custom_data()
		var test = tilemap.local_to_map(tilemap.to_local(Vector2i(cell.x, cell.y - 16)))
		print(tilemap.to_local(Vector2i(cell.x, cell.y - 16)))
		var tileset = tilemap.tile_set
		#var tile_cell_data = tilemap.get_cell_tile_data(test)
		#var level = tile_cell_data.get_custom_data("level")
		#var tile_data_entry = tileset.get_tile_data(source_id)

		tile_data.append({
			"pos": cell,
			"source": source_id,
			"atlas": atlas,
			"alt": alt,
			#"level": level
		})


	file.store_var(tile_data)
	var gnd_tilemap = $AllMoving/Tilemaps/GroundTilemap
	var gnd_used = gnd_tilemap.get_used_cells()
	var gnd_tile_data := []
	for cell in gnd_used:
		var source_id = gnd_tilemap.get_cell_source_id(cell)
		var atlas = gnd_tilemap.get_cell_atlas_coords(cell)
		var alt = gnd_tilemap.get_cell_alternative_tile(cell)
		#var level = tilemap.get_custom_data()
		var test = gnd_tilemap.local_to_map(gnd_tilemap.to_local(Vector2i(cell.x, cell.y)))
		#print(gnd_tilemap.to_local(Vector2i(cell.x, cell.y)))
		var tileset = gnd_tilemap.tile_set
		#var tile_cell_data = tilemap.get_cell_tile_data(test)
		#var level = tile_cell_data.get_custom_data("level")
		#var tile_data_entry = tileset.get_tile_data(source_id)


		gnd_tile_data.append({
			"pos": cell,
			"source": source_id,
			"atlas": atlas,
			"alt": alt,
			#"level": level
		})


	# Store the tile data
	file.store_var(gnd_tile_data)

	file.close()

func load_dataRESET():
	if FileAccess.file_exists(savepathRESET):
		var file = FileAccess.open(savepathRESET, FileAccess.READ)
		
		# Load player data
		PlayerGlobals.selected_plant = file.get_var()
		PlayerGlobals.money = file.get_var()
		for i in 11:
			player.inv.slots[i].amount = file.get_var()
		player.global_position = file.get_var()
		
		# Load tilemap
		var tilemap = $AllMoving/Tilemaps/SeedTilemap
		var gnd_tilemap = $AllMoving/Tilemaps/GroundTilemap

		# Place tiles back on
		tilemap.clear()  # clear existing tiles
		#gnd_tilemap.clear()

		var tile_data = file.get_var()
		var gnd_tile_data = file.get_var()

		for tile_info in tile_data:
			tilemap.set_cell(
				tile_info["pos"], 
				tile_info["source"], 
				tile_info["atlas"], 
				tile_info["alt"],
			)
			#var lev = (tile_info["level"])
			#print(tile_info["level"])

			#seed_handlingALT(tile_info["pos"], lev, tile_info["atlas"], 2)



		for gnd_tile_info in gnd_tile_data:
			gnd_tilemap.set_cell(
				gnd_tile_info["pos"], 
				gnd_tile_info["source"], 
				gnd_tile_info["atlas"], 
				gnd_tile_info["alt"],
			)

		file.close() #apparently this helps
		emit_signal("update")
	else:
		print("No data saved!")

func _on_restart_pressed() -> void:
	load_dataRESET()
	save()
