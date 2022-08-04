extends Node2D

var pathing = Pathing.new()
var selected = null

signal enemy_turn_complete
signal lock_released

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameBoard.initialize($UIManager)
	$UIManager.initialize($GameBoard)
	
	$GameBoard.add_unit($GameBoard.UnitType.HUMAN, Vector2(1,1), true)
	$GameBoard.add_unit($GameBoard.UnitType.ARCHER, Vector2(2,1), true)
	$GameBoard.add_unit($GameBoard.UnitType.ORC, Vector2(3,3), false)
	$GameBoard.add_unit($GameBoard.UnitType.ORC, Vector2(3,5), false)
	$GameBoard.add_unit($GameBoard.UnitType.ORC, Vector2(2,4), false)
	$GameBoard.add_unit($GameBoard.UnitType.ORC, Vector2(4,4), false)
