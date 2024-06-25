extends CanvasLayer
signal start_game


func _ready():
	$StartButton.show()


func _process(delta):
	pass


func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
	
func add_item(item):
	$Inventory/ItemSprite.set_texture(item.get_texture())
