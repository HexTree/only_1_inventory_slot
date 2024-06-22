extends Node2D

@onready var tile_map = $"../TileMap"
@onready var action_timer = $"../ActionTimer"

var MOVEMENT_SPEED = 4
var grid_position = Vector2.ZERO
var is_busy = false
var current_movement = null
var movement_queue = []

func _ready():
	position = tile_map.map_to_local(grid_position)

func _input(event):
	if event is InputEventKey and event.is_action_type():
		if event.is_pressed():
			# Add the movement to the queue if not already present
			if Input.is_action_pressed("left") and "left" not in movement_queue:
				movement_queue.append("left")
			elif Input.is_action_pressed("right") and "right" not in movement_queue:
				movement_queue.append("right")
			elif Input.is_action_pressed("up") and "up" not in movement_queue:
				movement_queue.append("up")
			elif Input.is_action_pressed("down") and "down" not in movement_queue:
				movement_queue.append("down")
		else:
			# Remove the movement from the queue if key is released
			if not Input.is_action_pressed("left") and "left" in movement_queue:
				movement_queue.erase("left")
			if not Input.is_action_pressed("right") and "right" in movement_queue:
				movement_queue.erase("right")
			if not Input.is_action_pressed("up") and "up" in movement_queue:
				movement_queue.erase("up")
			if not Input.is_action_pressed("down") and "down" in movement_queue:
				movement_queue.erase("down")

		# Start movement if not busy
		if not is_busy:
			handle_movement()

func handle_movement():
	if is_busy or not movement_queue:
		return

	current_movement = movement_queue[-1]
	is_busy = true
	update_grid_position(current_movement)

	if $AnimationPlayer.current_animation != current_movement:
		$AnimationPlayer.play(current_movement)

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
	$AnimationPlayer.stop()
	is_busy = false

	if movement_queue:
		handle_movement()
	else:
		action_timer.start()

func _on_action_timer_timeout():
	if not is_busy:
		handle_movement()
