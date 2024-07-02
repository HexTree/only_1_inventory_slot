extends Node2D

@onready var HUD = $"../HUD"
var TILE_SIZE = Vector2i(16, 16)
var grid_size
var tile_map
var item_map = {}
var equipped_item = null

func _ready():
	grid_size = Vector2(randi_range(16, 32), randi_range(16, 32))
	
	var tile_set = load("res://desert.tres")
	
	tile_map = TileMap.new()
	tile_map.tile_set = tile_set
	add_child(tile_map)
	tile_map.z_index = -1
	
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var tile = Vector2i(1, 6)
			if x == 0:
				if y == 0:
					tile = Vector2i(0, 5)
				elif y == grid_size.y-1:
					tile = Vector2i(0, 7)
				else:
					tile = Vector2i(0, 6)
			elif x == grid_size.x-1:
				if y == 0:
					tile = Vector2i(2, 5)
				elif y == grid_size.y-1:
					tile = Vector2i(2, 7)
				else:
					tile = Vector2i(2, 6)
			elif y == 0:
				tile = Vector2i(1, 5)
			elif y == grid_size.y-1:
				tile = Vector2i(1, 7)
			if tile == Vector2i(1, 6):
				if randf() < 0.05:
					tile = Vector2i(3, 18)
				elif randf() < 0.05:
					tile = Vector2i(3, 3)
			tile_map.set_cell(0, Vector2i(x, y), 0, tile)

	# Instantiate an item with the specified sprite and place it randomly on the tilemap
	for i in range(30):
		spawn_random_item()

	# spawn player
	$Player/Character.add_child(load("res://guy.tscn").instantiate())
	$Player.character.init_grid_position(tile_map, Vector2i(int(grid_size.x / 2), grid_size.y - 1))
	$Player.character.z_index = 1
	
	$AI/Character.add_child(load("res://girl.tscn").instantiate())
	$AI.character.init_grid_position(tile_map, Vector2i(3, 4))
	$AI.character.z_index = 1
	
	handle_turns()

func _process(delta):
	pass

func handle_turns():
	var player_turn = true
	while true:
		if player_turn:
			$Player.do_move()
			await $Player/Character.move_completed
			check_for_item($Player.character.grid_position)
		else:
			$AI.random_walk()
			await $AI/Character.move_completed
			check_for_item($AI.character.grid_position)
		player_turn = not player_turn

func spawn_random_item():
	var item = load("res://item.tscn").instantiate()
	add_child(item)
	
	var item_paths = ["res://Art/FantasyWeaponIcons_png/axes/axe_01_t.png",
	"res://Art/FantasyWeaponIcons_png/staves/stave_03_t.png",
	"res://Art/FantasyWeaponIcons_png/flail/flail_05_t.png"]
	
	# Set the sprite
	item.sprite.texture = load(item_paths.pick_random())
	
	# Get random position within the tilemap
	var random_position = null
	while random_position == null or random_position in item_map:
		random_position = Vector2i(randi_range(0, grid_size.x - 1), randi_range(0, grid_size.y - 1))
	item.init_grid_position(tile_map, random_position)
	item.z_index = 0

	# Add item to the item map
	item_map[random_position] = item

func check_for_item(grid_position):
	if grid_position in item_map:
		var item = item_map[grid_position]
		HUD.add_item(item)  # Add item to HUD
		equipped_item = item
		item_map.erase(grid_position)
		item.sprite.visible = false
		print("Item collected at position: ", grid_position)


