extends Control

export(bool) var ground_slot

onready var empty_texture = preload("res://images/ui/item_slot_empty.png")
onready var filled_texture = preload("res://images/ui/item_slot.png")
onready var filled_texture_drop = preload("res://images/ui/item_slot_drop.png")

func clear():
	$ItemStatsDisplay.visible = false
	$SlotBackground.texture = empty_texture

func set_item(item):
	if item == null:
		clear()
		return
	$ItemStatsDisplay.set_item(item)
	$ItemStatsDisplay.visible = true
	if ground_slot:
		$SlotBackground.texture = filled_texture_drop
	else:
		$SlotBackground.texture = filled_texture
