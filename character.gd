extends Node2D

@onready var tile_map: TileMap = $"../../TileMap"
@onready var animation_player = $"AnimationPlayer"

var MOVEMENT_SPEED = 8
var grid_position = Vector2.ZERO

func _ready():
	if tile_map == null:
		print("Error: TileMap is not assigned or found.")
	else:
		position = tile_map.map_to_local(grid_position)

# This function handles the movement logic
func move_character(direction):
	update_grid_position(direction)
	if animation_player.current_animation != direction:
		animation_player.play(direction)

	var destination = tile_map.map_to_local(grid_position)
	var tween = create_tween()
	tween.tween_property(self, "position", destination, 1.0 / MOVEMENT_SPEED)
	tween.connect("finished", self._on_tween_finished)

# This function updates the grid position based on the direction
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

# This function handles the completion of the tween animation
func _on_tween_finished():
	animation_player.pause()
	emit_signal("move_completed")

# Define the signal
signal move_completed
