extends Control

func set_value(value):
	$NumberLabel.text = value as String


func color_green():
	$NumberLabel.modulate = Color("#1ebc73")

func color_white():
	$NumberLabel.modulate = Color("#ffffff")

func color_red():
	$NumberLabel.modulate = Color("#e83b3b")
