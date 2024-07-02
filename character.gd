extends Node2D

var tile_map: TileMap

var MOVEMENT_SPEED = 10
var grid_position

func _ready():
	pass
		
func init_grid_position(tile_map, v):
	self.tile_map = tile_map
	self.grid_position = v
	self.position = tile_map.map_to_local(self.grid_position)
	adjust_sprite_offset()

func move_character(direction):
	update_grid_position(direction)
	if $AnimationNode/AnimationPlayer.current_animation != direction:
		$AnimationNode/AnimationPlayer.play(direction)

	var destination = tile_map.map_to_local(grid_position)
	var tween = create_tween()
	tween.tween_property(self, "position", destination, 1.0 / MOVEMENT_SPEED)
	tween.connect("finished", self._on_tween_finished)

func update_grid_position(direction):
	match direction:
		"left":
			grid_position.x -= 1
		"right":
			grid_position.x += 1
		"up":
			grid_position.y -= 1
		"down":
			grid_position.y += 1

func _on_tween_finished():
	$AnimationNode/AnimationPlayer.pause()
	emit_signal("move_completed")

func adjust_sprite_offset():
	var tile_size = tile_map.tile_set.tile_size
	var sprite_rect = $AnimationNode/Sprite2D.get_rect()
	# Assuming you want the bottom of the sprite to be 1 pixel above the bottom of the tile
	var offset_y = (tile_size.y - sprite_rect.size.y) / 2 + 1
	$AnimationNode/Sprite2D.offset = Vector2(0, offset_y)

# New method to check if a cell is walkable
func can_move(grid_cell: Vector2) -> bool:
	# Check if the tile exists in the tilemap at the given grid cell
	return tile_map.get_cell_tile_data(0, grid_cell) != null

signal move_completed
