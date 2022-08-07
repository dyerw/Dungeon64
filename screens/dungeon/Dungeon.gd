extends Node2D

var pathing = Pathing.new()
var selected = null

signal battle_completed

# Called when the node enters the scene tree for the first time.
func _ready():
	$GameBoard.initialize($UIManager)
	$UIManager.initialize($GameBoard)
	$GameBoard.connect("battle_completed", self, "_on_battle_completed")

func intialize(party, enemies):
	print("Being initialized with party: ", party)
	var i = 0
	for unit in party:
		unit.end_turn()
		$GameBoard.add_unit(unit, Vector2(i + 1, 1), true)
		i += 1
	i = 0
	for unit in enemies:
		$GameBoard.add_unit(unit, Vector2(6 - i, 6), false)
		i += 1

func _on_battle_completed():
	emit_signal("battle_completed")
