extends "res://units/BaseUnit/BaseUnit.gd"

var skeleton = preload("res://units/Skeleton/Skeleton.tscn")

func on_unit_died(unit, pos, game_board):
	var screen_lock = ScreenLock.new()
	screen_lock.request(self)
	game_board.add_unit(skeleton.instance(), pos, false)
	$AnimatedSprite.animation = "attack"
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.animation = "default"
	screen_lock.release(self)
	return true
