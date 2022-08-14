extends "res://units/BaseUnit/BaseUnit.gd"


func end_turn():
	.end_turn()
	if current_health < get_max_health():
		var screen_lock = ScreenLock.new()
		screen_lock.request(self)
		set_current_health(get_max_health())
		$AnimatedSprite.animation = "heal"
		yield($AnimatedSprite, "animation_finished")
		$AnimatedSprite.animation = "default"
		emit_signal("end_turn_complete")
		screen_lock.release(self)
