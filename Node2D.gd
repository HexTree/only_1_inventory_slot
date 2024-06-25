extends Node2D

@onready var tile_map = $"../TileMap"

var grid_position = Vector2(3, 3)

# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite_size = $Sprite2D.get_rect().size
	var max_width = max(sprite_size.x, sprite_size.y)
	scale *= (tile_map.tile_set.tile_size.x / max_width)
	position = tile_map.map_to_local(grid_position)
	
	get_parent().item_map[grid_position] = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func get_texture():
	return $Sprite2D.texture
