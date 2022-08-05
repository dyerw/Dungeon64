extends Control

signal play_button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayButton_pressed():
	emit_signal("play_button_pressed")
