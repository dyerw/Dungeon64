extends Node
class_name DefaultEnemyBehavior

signal turn_completed
signal request_lock
signal release_lock

func take_turn(unit: Node2D, game_board) -> void:
	var screen_lock = ScreenLock.new()
	screen_lock.request(self)
	var target = game_board.get_closest_unit(unit, true)
	if target != null:
		game_board.move_toward_unit(unit, target)
		if unit.is_moving:
			yield(unit, "movement_complete")
		if game_board.resolve_attack(unit, target):
			yield(unit, "attack_complete")
	screen_lock.release(self)
	emit_signal("turn_completed")
