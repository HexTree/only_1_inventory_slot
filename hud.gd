extends CanvasLayer

signal start_game

@onready var item_sprite = $"Inventory/ItemSprite"
@onready var color_rect = $"Inventory/ColorRect"

func _ready():
	pass

func _process(delta):
	pass

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func add_item(item):
	# Set the texture of the ItemSprite to the item's texture
	item_sprite.texture = item.sprite.texture
	
	# Adjust the size of the ItemSprite to match the size of the ColorRect
	var rect_size = color_rect.size
	var texture_size = item_sprite.texture.get_size()
	var scale = rect_size / texture_size
	item_sprite.scale = scale
