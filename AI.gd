extends Node

@onready var character = $"Character"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_walk():
	var directions = ["left", "right", "up", "down"]
	var walkable_directions = []
	for direction in directions:
		var target_grid_position = character.grid_position
		match direction:
			"left":
				target_grid_position.x -= 1
			"right":
				target_grid_position.x += 1
			"up":
				target_grid_position.y -= 1
			"down":
				target_grid_position.y += 1
		if character.can_move(target_grid_position):
			walkable_directions.append(direction)
	
	if walkable_directions:
		var chosen_direction = walkable_directions[randi() % walkable_directions.size()]
		character.move_character(chosen_direction)
		await character.move_completed
