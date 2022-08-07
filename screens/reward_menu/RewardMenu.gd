extends Control

signal item_chosen

var selected_button_texture = preload("res://images/ui/screen_wide_button_selected.png")

var _items = []
var _selected_item = null 

onready var button_one = get_node("%ItemOneButton")
onready var button_two = get_node("%ItemTwoButton")
onready var item_display_one = get_node("%ItemOneStatsDisplay")
onready var item_display_two = get_node("%ItemTwoStatsDisplay")
onready var continue_button = get_node("%ContinueButton")


func initialize(items):
	_items = items
	item_display_one.set_item(items[0])
	item_display_two.set_item(items[1])

func _select_item(i):
	continue_button.disabled = false
	if i == 0:
		_selected_item = _items[0]
		button_one.disabled = true
		button_two.disabled = false
	else:
		_selected_item = _items[1]
		button_one.disabled = false
		button_two.disabled = true


func _on_ItemOneButton_pressed():
	_select_item(0)


func _on_ItemTwoButton_pressed():
	_select_item(1)


func _on_ContinueButton_pressed():
	emit_signal("item_chosen", _selected_item)
