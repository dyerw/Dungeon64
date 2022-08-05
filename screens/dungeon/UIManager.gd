extends Node2D


var _locked = false
var _lock_ids = []

var _selected = null
var _game_board


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Public
func initialize(game_board):
	_game_board = game_board

func player_unit_left_clicked(unit: Node2D):
	if _locked:
		return
	_set_selected(unit)

func player_unit_right_clicked(unit: Node2D):
	if _locked:
		return
	pass

func enemy_unit_left_clicked(unit: Node2D):
	if _locked:
		return
	pass

func enemy_unit_right_clicked(unit: Node2D):
	if _locked:
		return
	var attacked = _game_board.resolve_attack(_selected, unit)
	if attacked:
		_set_selected(null)

func empty_tile_right_clicked(pos: Vector2):
	if _locked:
		return
	var moved = _game_board.move_unit(_selected, pos)
	if moved:
		_set_selected(null)

func empty_tile_left_clicked(pos: Vector2):
	if _locked:
		return
	pass

func end_turn_clicked():
	if _locked:
		return
	_set_selected(null)
	_game_board.end_turn()
	pass

# Private

func _set_selected(unit: Node2D):
	_selected = unit
	$UIOverlayTileMap.clear()
	if _selected != null:
		_highlight_moveable(_selected)
		_highlight_attackable(_selected)

func _highlight_attackable(unit: Node2D):
	$UIOverlayTileMap.highlight_tiles_attackable(
		_game_board.get_attackable_tiles(unit)
	)

func _highlight_moveable(unit: Node2D):
	$UIOverlayTileMap.highlight_tiles_moveable(
		_game_board.get_reachable_positions(unit)
	)

# Signal Handlers

func _on_request_lock(id):
	print("locking")
	_locked = true
	if !_lock_ids.has(id):
		_lock_ids.push_back(id)

func _on_release_lock(id):
	if _lock_ids.has(id):
		_lock_ids.remove(_lock_ids.find(id))
		if _lock_ids.size() == 0:
			print("unlocking")
			_locked = false
