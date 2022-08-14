extends Node2D


var _locked = false
var _lock_ids = []

var _selected = null
var _game_board

var _hovered_tile = null

var blue_styleboxflat = preload("res://resources/stylebox/blue_styleboxflat.tres")
var red_styleboxflat = preload("res://resources/stylebox/red_styleboxflat.tres")

func _input(event):
	var mouse_motion = event as InputEventMouseMotion
	if mouse_motion:
		var tile = $UIOverlayTileMap.world_to_map(mouse_motion.position)
		if tile != _hovered_tile:
			_hovered_tile = tile
			_on_mouse_entered_tile(tile)

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
	if _selected != null:
		var attacked = _game_board.resolve_attack(_selected, unit)
		if attacked:
			_set_selected(null)

func enemy_unit_right_clicked(unit: Node2D):
	if _locked:
		return

func empty_tile_right_clicked(pos: Vector2):
	if _locked:
		return
	_set_selected(null)

func empty_tile_left_clicked(pos: Vector2):
	if _locked:
		return
	if _selected != null:
		var moved = _game_board.move_unit(_selected, pos)
		if moved:
			$ArrowOverlayTileMap.clear()
			_set_selected(null)

func _on_EndTurnButton_pressed():
	_set_selected(null)
	_game_board.end_turn()
	pass

# Private

func _show_unit_stats(unit):
	if unit:
		$LineStatDisplay.visible = true
		$LineStatDisplay.display_unit(unit)
		if _game_board.is_enemy_unit(unit):
			$StatDisplayBackingPanel.add_stylebox_override("panel", red_styleboxflat)
		else:
			$StatDisplayBackingPanel.add_stylebox_override("panel", blue_styleboxflat)
	else:
		$StatDisplayBackingPanel.remove_stylebox_override("panel")
		$LineStatDisplay.visible = false

func _set_selected(unit: Node2D):
	_selected = unit
	$ArrowOverlayTileMap.clear()
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

func _on_mouse_entered_tile(tile: Vector2):
	if _selected != null and _selected.remaining_movement > 0:
		var path = _game_board.get_shortest_path(_selected, tile)
		if path.size() - 1 <= _selected.remaining_movement:
			$ArrowOverlayTileMap.draw_path(path)
		else:
			$ArrowOverlayTileMap.draw_path([])
	var unit_on_tile = _game_board.get_unit_by_grid_pos(tile)
	_show_unit_stats(unit_on_tile)

# Signal Handlers

func _on_request_lock(id):
	_locked = true
	$EndTurnButton.disabled = true
	if !_lock_ids.has(id):
		_lock_ids.push_back(id)

func _on_release_lock(id):
	if _lock_ids.has(id):
		_lock_ids.remove(_lock_ids.find(id))
		if _lock_ids.size() == 0:
			$EndTurnButton.disabled = false
			_locked = false


