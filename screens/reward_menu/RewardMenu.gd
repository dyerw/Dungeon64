extends Control

var health_stat_display = preload("res://ui/stat_display/HealthStatDisplay.tscn")
var movement_stat_display = preload("res://ui/stat_display/MovementStatDisplay.tscn")
var range_stat_display = preload("res://ui/stat_display/RangeStatDisplay.tscn")
var damage_stat_display = preload("res://ui/stat_display/DamageStatDisplay.tscn")

var selected_button_texture = preload("res://images/ui/screen_wide_button_selected.png")

var stat_to_display = {
	"damage": damage_stat_display,
	"movement": movement_stat_display,
	"health": health_stat_display,
	"attack_range": range_stat_display
}

var _selected_item = null 

onready var button_one = get_node("%ItemOneButton")
onready var button_two = get_node("%ItemTwoButton")
onready var item_display_one = get_node("%ItemOneDisplay")
onready var item_display_two = get_node("%ItemTwoDisplay")


func initialize(items):
	item_display_one.set_item(items[0]["rarity"], items[0]["type"])
	display_stats(items[0], button_one)
	
	item_display_two.set_item(items[1]["rarity"], items[1]["type"])
	display_stats(items[1], button_two)


func display_stats(item, button):
	var left_margin = 13
	var i = 0
	for stat in item.stats:
		var stat_display = stat_to_display[stat].instance()
		stat_display.set_value(item.stats[stat])
		button.add_child(stat_display)
		stat_display.rect_position = Vector2(13 + i * left_margin, 4)
		stat_display.mouse_filter = MOUSE_FILTER_PASS
		i += 1


func _select_item(i):
	if i == 0:
		button_one.disabled = true
		button_two.disabled = false
	else:
		button_one.disabled = false
		button_two.disabled = true


func _on_ItemOneButton_pressed():
	_select_item(0)


func _on_ItemTwoButton_pressed():
	_select_item(1)
