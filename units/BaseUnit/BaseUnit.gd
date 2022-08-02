extends Node2D

export(int) var movement
var remaining_movement: int

# Called when the node enters the scene tree for the first time.
func _ready():
	remaining_movement = movement

func move(pos: Vector2):
	$AnimatedSprite.animation = "move"
