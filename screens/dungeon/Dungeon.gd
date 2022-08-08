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
		
		
	# Enemy placement
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var taken_positions = []
	var enemies_to_place: Array = enemies.duplicate()
	while enemies_to_place.size() > 0:
		var pos = Vector2(rng.randi_range(1,6), rng.randi_range(4,6))
		if !(pos in taken_positions):
			var enemy = enemies_to_place.pop_front()
			$GameBoard.add_unit(enemy, pos, false)
			taken_positions.push_back(pos)

func _on_battle_completed():
	emit_signal("battle_completed")
