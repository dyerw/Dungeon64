extends Control


signal death_screen_closed


# Called when the node enters the scene tree for the first time.
func initialize(depth: int):
	$DepthLabel.text = str(depth)


func _on_CloseButton_pressed():
	emit_signal("death_screen_closed")
