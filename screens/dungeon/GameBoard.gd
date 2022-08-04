extends Node2D

var pathing = Pathing.new()

var _player_units = []
var _enemy_units = []
var _grid_to_unit = {}
var _input_handler

export var human: PackedScene
export var orc: PackedScene
export var archer: PackedScene

enum UnitType {
	HUMAN,
	ORC,
	ARCHER
}

func _ready():
	pass # Replace with function body.
# Public

func initialize(input_handler):
	_input_handler = input_handler

func add_unit(type, grid_pos: Vector2, is_player: bool):
	var u
	match type:
		UnitType.HUMAN:
			u = human.instance()
		UnitType.ORC:
			u = orc.instance()
		UnitType.ARCHER:
			u = archer.instance()
	add_child(u)
	u.position = $TerrainTileMap.map_to_world(grid_pos)
	_update_grid_to_unit(u, grid_pos)
	if is_player:
		_player_units.push_back(u)
	else:
		_enemy_units.push_back(u)
	u.connect("died", self, "_on_Unit_died")
	u.connect("request_lock", _input_handler, "_on_Unit_request_lock")
	u.connect("release_lock", _input_handler, "_on_Unit_release_lock")

func get_unit_grid_pos(unit: Node2D):
	return $TerrainTileMap.world_to_map(unit.position)

# Will move unit if it has remaining moves to do so -> returns true
# No-op if it's an illegal move -> returns false
func move_unit(unit: Node2D, grid_pos: Vector2) -> bool:
	var unit_grid_pos = get_unit_grid_pos(unit)
	var path = pathing.get_shortest_path(
		unit_grid_pos,
		grid_pos,
		get_blocked_tiles()
	)
	if path.size() - 1 > unit.remaining_movement:
		return false
	var world_path = PoolVector2Array()
	for p in path:
		world_path.push_back($TerrainTileMap.map_to_world(p))
	unit.move(world_path)
	_update_grid_to_unit(unit, grid_pos)
	return true

func get_blocked_tiles() -> PoolVector2Array:
	var blocked_tiles = $TerrainTileMap.get_blocking_tiles()
	for u in _player_units:
		var u_grid_pos = get_unit_grid_pos(u)
		blocked_tiles.push_back(Vector2(u_grid_pos.x, u_grid_pos.y))
	for u in _enemy_units:
		var u_grid_pos = get_unit_grid_pos(u)
		blocked_tiles.push_back(Vector2(u_grid_pos.x, u_grid_pos.y))
	return blocked_tiles

# Returns null if no unit
func get_unit_by_grid_pos(grid_pos: Vector2) -> Node2D:
	if grid_pos in _grid_to_unit:
		return _grid_to_unit[grid_pos]
	return null

func distance_to_unit(grid_pos: Vector2, unit: Node2D):
	return grid_pos.distance_to(get_unit_grid_pos(unit))

func distance_between_units(u1: Node2D, u2: Node2D):
	return distance_to_unit(get_unit_grid_pos(u1), u2)

func get_reachable_positions(unit: Node2D) -> PoolVector2Array:
	var tiles = pathing.get_reachable_positions(
		$TerrainTileMap.world_to_map(unit.position),
		unit.remaining_movement,
		get_blocked_tiles()
	)
	return tiles

func get_attackable_tiles(unit: Node2D) -> PoolVector2Array:
	var tiles = PoolVector2Array()
	if unit.remaining_attacks <= 0:
		return tiles
	for x in range(8):
		for y in range(8):
			var v = Vector2(x, y)
			var u = get_unit_by_grid_pos(v)
			if u != null:
				if distance_to_unit(v, unit) <= unit.attack_range and is_enemy_unit(u):
					tiles.push_back(v)
	return tiles

func resolve_attack(attacker: Node2D, defender: Node2D) -> bool:
	if distance_between_units(attacker, defender) <= attacker.attack_range and attacker.remaining_attacks > 0:
		attacker.attack()
		defender.take_damage(attacker.damage)
		return true
	return false

func can_move(unit: Node2D, to: Vector2):
	return pathing.is_reachable(
		$TerrainTileMap.world_to_map(unit.position), 
		to, 
		unit.remaining_movement, 
		get_blocked_tiles()
	)

func is_enemy_unit(unit: Node2D) -> bool:
	return unit in _enemy_units

func is_player_unit(unit: Node2D) -> bool:
	return unit in _player_units

func move_toward_unit(u1: Node2D, u2: Node2D):
	var u1_grid_pos = get_unit_grid_pos(u1)
	var u2_grid_pos = get_unit_grid_pos(u2)
	var blocked_tiles = get_blocked_tiles()
	blocked_tiles.remove(blocked_tiles.find(u2_grid_pos))
	var path_to_target = pathing.get_shortest_path(
		u1_grid_pos, 
		u2_grid_pos, 
		blocked_tiles
	)
	if path_to_target.size() >= 3:
		var move_to_index = min(path_to_target.size() - 2, u1.remaining_movement)
		move_unit(u1, path_to_target[move_to_index])

func end_turn():
	for u in _player_units:
		u.end_turn()

# Private

func _update_grid_to_unit(unit: Node2D, new_grid_pos: Vector2):
	var old_pos = get_unit_grid_pos(unit)
	if old_pos in _grid_to_unit:
		_grid_to_unit.erase(get_unit_grid_pos(unit))
	_grid_to_unit[new_grid_pos] = unit

# Signal Handlers

func _on_Unit_died(unit: Node2D):
	_player_units.erase(unit)
	_enemy_units.erase(unit)
	_grid_to_unit.erase(get_unit_grid_pos(unit))

func _on_TerrainTileMap_tile_left_clicked(pos: Vector2):
	# FXIME: Button hack
	if pos == Vector2(0,0):
		_input_handler.end_turn_clicked()
	
	var u = get_unit_by_grid_pos(pos)
	if u != null:
		if u in _player_units:
			_input_handler.player_unit_left_clicked(u)
		elif u in _enemy_units:
			_input_handler.enemy_unit_left_clicked(u)
		else:
			push_warning("User left clicked on a unit not tracked by Units")
	else:
		_input_handler.empty_tile_left_clicked(pos)

func _on_TerrainTileMap_tile_right_clicked(pos: Vector2):
	var u = get_unit_by_grid_pos(pos)
	if u != null:
		if u in _player_units:
			_input_handler.player_unit_right_clicked(u)
		elif u in _enemy_units:
			_input_handler.enemy_unit_right_clicked(u)
		else:
			push_warning("User right clicked on a unit not tracked by Units")
	else:
		_input_handler.empty_tile_right_clicked(pos)
