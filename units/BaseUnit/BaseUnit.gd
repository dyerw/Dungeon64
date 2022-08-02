extends Node2D

export(int) var movement
var remaining_movement: int

# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_movement = movement

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
