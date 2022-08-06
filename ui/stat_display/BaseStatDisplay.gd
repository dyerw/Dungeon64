extends Control

var value setget _set_value

func _set_value(v):
	value = v
	$NumberLabel.text = value
