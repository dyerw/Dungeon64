extends Control

onready var empty_texture = preload("res://images/ui/item_slot_empty.png")
onready var filled_texture = preload("res://images/ui/item_slot.png")

func clear():
	$ItemStatsDisplay.visible = false
	$SlotBackground.texture = empty_texture

func set_item(item):
	if item == null:
		clear()
		return
	$ItemStatsDisplay.set_item(item)
	$ItemStatsDisplay.visible = true
	$SlotBackground.texture = filled_texture
