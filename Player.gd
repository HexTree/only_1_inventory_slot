extends Node2D

@onready var character = $"Character"
@onready var camera = $"Camera2D"

var is_busy = false
var current_movement = null
var movement_queue = []

func _ready():
	if character == null:
		print("Error: Character is not assigned or found.")
	else:
		character.connect("move_completed", self._on_move_completed)

	if camera == null:
		print("Error: Camera is not assigned or found.")
	else:
		camera.make_current()

func _input(event):
	if event is InputEventKey and event.is_action_type():
		if event.is_pressed():
			if Input.is_action_pressed("left") and "left" not in movement_queue:
				movement_queue.append("left")
			elif Input.is_action_pressed("right") and "right" not in movement_queue:
				movement_queue.append("right")
			elif Input.is_action_pressed("up") and "up" not in movement_queue:
				movement_queue.append("up")
			elif Input.is_action_pressed("down") and "down" not in movement_queue:
				movement_queue.append("down")
		else:
			if not Input.is_action_pressed("left") and "left" in movement_queue:
				movement_queue.erase("left")
			if not Input.is_action_pressed("right") and "right" in movement_queue:
				movement_queue.erase("right")
			if not Input.is_action_pressed("up") and "up" in movement_queue:
				movement_queue.erase("up")
			if not Input.is_action_pressed("down") and "down" in movement_queue:
				movement_queue.erase("down")

		if not is_busy:
			handle_movement()

func handle_movement():
	if is_busy or movement_queue.size() == 0:
		return

	current_movement = movement_queue[-1]
	is_busy = true
	character.move_character(current_movement)

func _on_move_completed():
	is_busy = false
	if movement_queue.size() > 0:
		handle_movement()
