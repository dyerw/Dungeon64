extends Node2D

export(int) var movement
export(bool) var allied
export(int) var max_health

var remaining_movement: int
var current_health: int

signal move_complete

# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_movement = movement
	current_health = max_health
	$HealthPips.health = current_health

func can_move(from: Vector2, to: Vector2):
	return from.distance_to(to) <= remaining_movement

func move(to: Vector2, cost: int):
	remaining_movement -= cost
	$AnimatedSprite.animation = "move"
	$MovementTween.interpolate_property(
		self, 
		"position",
		position, 
		to, 
		1,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	$MovementTween.start()
	yield($MovementTween, "tween_completed")
	$AnimatedSprite.animation = "default"
	emit_signal("move_complete")

func end_turn():
	print(self, "ending turn")
	remaining_movement = movement
