extends Node2D

export(int) var movement
export(int) var attacks
export(int) var max_health
export(int) var attack_range
export(int) var damage
export(String) var unit_name

var pathing = Pathing.new()
var remaining_movement: int
var remaining_attacks: int
var current_health: int setget set_current_health
var is_moving

var equipped_item = null

# While units do things that should disable controls
# they can request and release controls
signal request_lock
signal release_lock
signal died
signal movement_complete
signal attack_complete

func get_movement():
	return get_modified_stats()["movement"]

func get_attacks():
	return get_modified_stats()["attacks"]

func get_max_health():
	return get_modified_stats()["max_health"]

func get_attack_range():
	return get_modified_stats()["attack_range"]

func get_damage():
	return get_modified_stats()["damage"]

func get_base_movement():
	return movement

func get_base_attacks():
	return attacks

func get_base_max_health():
	return max_health

func get_base_attack_range():
	return attack_range

func get_base_damage():
	return damage

func set_current_health(h: int):
	current_health = h
	$HealthPips.health = h

# To be called when the unit is between battles
func between_game_reset():
	set_current_health(get_max_health())
	self.visible = true
	$AnimatedSprite.animation = "default"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	remaining_movement = movement
	remaining_attacks = attacks
	set_current_health(max_health)

func take_damage(d: int):
	$HitAudioStreamPlayer.play()
	
	# Did we die???
	if d >= current_health:
		var screen_lock = ScreenLock.new()
		screen_lock.request(self)
		set_current_health(0)
		$AnimatedSprite.animation = "die"
		yield($AnimatedSprite, "animation_finished")
		emit_signal("died", self)
		screen_lock.release(self)
		
		self.visible = false
	else:
		set_current_health(current_health - d)

func move(path: PoolVector2Array):
	is_moving = true
	var screen_lock = ScreenLock.new()
	screen_lock.request(self)
	remaining_movement -= path.size() - 1
	$AnimatedSprite.animation = "move"
	for i in path.size() - 1:
		$MovementTween.interpolate_property(
			self, 
			"position",
			path[i], 
			path[i+1],
			0.5,
			Tween.TRANS_LINEAR, 
			Tween.EASE_IN_OUT
		)
		$MovementTween.start()
		yield($MovementTween, "tween_completed")
	$AnimatedSprite.animation = "default"
	screen_lock.release(self)
	is_moving = false
	emit_signal("movement_complete")

func attack():
	var screen_lock = ScreenLock.new()
	screen_lock.request(self)
	remaining_attacks -= 1
	$AnimatedSprite.animation = "attack"
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.animation = "default"
	screen_lock.release(self)
	emit_signal("attack_complete")

# FIXME: Maybe name reset??
func end_turn():
	var attacks = get_attacks()
	remaining_attacks = get_attacks()
	remaining_movement = get_movement()

func get_modified_stats():
	var stats = {
		"movement": movement,
		"attacks": attacks,
		"max_health": max_health,
		"damage": damage,
		"attack_range": attack_range
	}
	if equipped_item != null:
		for stat in equipped_item.stats:
			stats[stat] += equipped_item.stats[stat]
	return stats

# Overridables

func on_unit_died(unit, pos, game_board):
	pass

