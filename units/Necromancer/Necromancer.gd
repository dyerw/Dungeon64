extends "res://units/BaseUnit/BaseUnit.gd"

var skeleton = preload("res://units/Skeleton/Skeleton.tscn")

export(int) var max_resurrects = 1
var resurrects = max_resurrects

func on_unit_died(unit, pos, game_board):
	if resurrects == 0 or unit.unit_name == "Skeleton":
		return false
	resurrects -= 1
	var screen_lock = ScreenLock.new()
	screen_lock.request(self)
	game_board.add_unit(skeleton.instance(), pos, false)
	$AnimatedSprite.animation = "attack"
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.animation = "default"
	screen_lock.release(self)
	return true

func end_turn():
	.end_turn()
	resurrects = max_resurrects
