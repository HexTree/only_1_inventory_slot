extends Node2D

@onready var sprite: Sprite2D = $"Sprite2D"
var tile_map: TileMap
var grid_position: Vector2

func _ready():
	pass

func init_grid_position(tile_map: TileMap, grid_position: Vector2):
	self.tile_map = tile_map
	self.grid_position = grid_position
	self.position = tile_map.map_to_local(grid_position)
	set_as_top_level(true)
	self.sprite.visible = true
	
	# Scale the sprite to fit 3/4 of the tile size
	var tile_size = tile_map.tile_set.tile_size
	var scale_factor = 0.85 * tile_size.x / sprite.texture.get_size().x
	sprite.scale = Vector2(scale_factor, scale_factor)
