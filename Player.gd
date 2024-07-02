extends Node2D

@onready var character = $"Character"

var lock_input = true

func _ready():
	if character == null:
		print("Error: Character is not assigned or found.")
	
	var camera = Camera2D.new()
	character.add_child(camera)
	camera.zoom = Vector2(2, 2)
	camera.make_current()

func _input(event):
	if event is InputEventKey and event.is_action_type():
		if event.is_pressed():
			var current_movement
			if Input.is_action_pressed("left"):
				current_movement = "left"
			elif Input.is_action_pressed("right"):
				current_movement = "right"
			elif Input.is_action_pressed("up"):
				current_movement = "up"
			elif Input.is_action_pressed("down"):
				current_movement = "down"
			if lock_input or current_movement == null:
				return
			var target_grid_position = character.grid_position
			match current_movement:
				"left":
					target_grid_position.x -= 1
				"right":
					target_grid_position.x += 1
				"up":
					target_grid_position.y -= 1
				"down":
					target_grid_position.y += 1
			if not character.can_move(target_grid_position):
				lock_input = false
				return
			lock_input = true
			character.move_character(current_movement)
		
func do_move():
	lock_input = false
