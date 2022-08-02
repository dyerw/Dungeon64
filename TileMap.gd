extends TileMap

signal tile_left_clicked
signal tile_right_clicked

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("tile_left_clicked", world_to_map(event.position))
	if event is InputEventMouseButton and event.button_index == BUTTON_RIGHT and event.pressed:
		emit_signal("tile_right_clicked", world_to_map(event.position))
