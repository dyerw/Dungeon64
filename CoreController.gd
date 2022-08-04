extends Node2D

export var human: PackedScene
export var orc: PackedScene
export var archer: PackedScene

var pathing = Pathing.new()
var _grid_to_unit = []
var _all_units = []
var _grid_to_blocked = []
var selected = null

var _locked = false
var _lock_ids = []

signal enemy_turn_complete
signal lock_released

func _initialize_grid(grid):
	grid.resize(8)
	for i in grid.size():
		var a = []
		a.resize(8)
		grid[i] = a

# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize_grid(_grid_to_unit)
	_initialize_grid(_grid_to_blocked)
	
	for n in range(8):
		_grid_to_blocked[0][n] = true
		_grid_to_blocked[n][0] = true
		_grid_to_blocked[7][n] = true
		_grid_to_blocked[n][7] = true
	
	var h = human.instance()
	var o = orc.instance()
	var o2 = orc.instance()
	var o3 = orc.instance()
	var o4 = orc.instance()
	add_child(o)
	add_child(o2)
	add_child(o3)
	add_child(o4)
	add_child(h)
	h.position = $TerrainTileMap.map_to_world(Vector2(1,1))
	update_grid(h, Vector2(1,1))
	update_grid(o, Vector2(3,3))
	update_grid(o2, Vector2(3,5))
	update_grid(o3, Vector2(2,4))
	update_grid(o4, Vector2(4,4))
	o.position = $TerrainTileMap.map_to_world(Vector2(3,3))
	o2.position = $TerrainTileMap.map_to_world(Vector2(3,5))
	o3.position = $TerrainTileMap.map_to_world(Vector2(2,4))
	o4.position = $TerrainTileMap.map_to_world(Vector2(4,4))
	
	var a = archer.instance()
	add_child(a)
	a.position = $TerrainTileMap.map_to_world(Vector2(2, 1))
	update_grid(a, Vector2(2,1))
	
	_all_units.push_back(o)
	_all_units.push_back(o2)
	_all_units.push_back(o3)
	_all_units.push_back(o4)

	_all_units.push_back(h)
	_all_units.push_back(a)
	
	for u in _all_units:
		u.connect("request_lock", self, "_on_Unit_request_lock")
		u.connect("release_lock", self, "_on_Unit_release_lock")
		u.connect("died", self, "_on_Unit_died")

func _on_Unit_died(unit: Node2D):
	_all_units.remove(_all_units.find(unit))
	clear_unit_from_grid(unit)

func _on_Unit_request_lock(id):
	_locked = true
	if !_lock_ids.has(id):
		_lock_ids.push_back(id)

func _on_Unit_release_lock(id):
	if _lock_ids.has(id):
		_lock_ids.remove(_lock_ids.find(id))
		if _lock_ids.size() == 0:
			_locked = false
			emit_signal("lock_released")

func clear_unit_from_grid(unit: Node2D):
	var old_position = $TerrainTileMap.world_to_map(unit.position)
	_grid_to_unit[old_position.x][old_position.y] = null

func update_grid(entity: Node2D, pos: Vector2):
	clear_unit_from_grid(entity)
	_grid_to_unit[pos.x][pos.y] = entity

func move_unit(entity: Node2D, pos: Vector2):
	var entity_map_pos = $TerrainTileMap.world_to_map(entity.position)
	var path = pathing.get_shortest_path(
		entity_map_pos,
		pos,
		get_blocking_grid()
	)
	var world_path = PoolVector2Array()
	for p in path:
		world_path.push_back($TerrainTileMap.map_to_world(p))
	entity.move(world_path)
	update_grid(entity, pos)

func get_unit(pos: Vector2) -> Node2D:
	return _grid_to_unit[pos.x][pos.y]

func get_blocking_grid() -> Array:
	var a = _grid_to_blocked.duplicate(true)
	for x in range(8):
		for y in range(8):
			a[x][y] = a[x][y] or _grid_to_unit[x][y] != null
	return a

func select_unit(unit: Node2D):
	if unit.allied:
		selected = unit
		var unit_grid_pos = $TerrainTileMap.world_to_map(unit.position)
		$UIOverlayTileMap.clear()
		highlight_moveable(unit)
		highlight_attackable(unit)

func distance_to_unit(grid_p: Vector2, unit: Node2D):
	return grid_p.distance_to($TerrainTileMap.world_to_map(unit.position))

func distance_between_units(u1: Node2D, u2: Node2D):
	return distance_to_unit($TerrainTileMap.world_to_map(u1.position), u2)

func get_attackable_tiles(unit: Node2D) -> PoolVector2Array:
	var tiles = PoolVector2Array()
	if unit.remaining_attacks <= 0:
		return tiles
	for x in range(8):
		for y in range(8):
			var v = Vector2(x, y)
			var u = get_unit(v)
			if distance_to_unit(v, unit) <= unit.attack_range and u != null and !u.allied:
				tiles.push_back(v)
	return tiles

func highlight_attackable(unit: Node2D):
	$UIOverlayTileMap.highlight_tiles_attackable(get_attackable_tiles(unit))

func highlight_moveable(unit: Node2D):
	var tiles = pathing.get_reachable_positions(
		$TerrainTileMap.world_to_map(unit.position),
		unit.remaining_movement,
		get_blocking_grid()
	)
	$UIOverlayTileMap.highlight_tiles_moveable(tiles)

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
		get_blocking_grid()
	)

func _on_TileMap_tile_left_clicked(pos: Vector2):
	if _locked:
		return
	
	if pos == Vector2(0,0):
		end_turn()
	
	var u = get_unit(pos)
	if u != null and u.allied:
		select_unit(u)

func _on_TileMap_tile_right_clicked(pos: Vector2):
	if _locked:
		return
	
	var u = get_unit(pos)
	if selected != null and u == null:
		if can_move(selected, pos):
			$UIOverlayTileMap.clear()
			move_unit(selected, pos)
			selected = null
	
	if selected != null and u != null and !u.allied:
		$UIOverlayTileMap.clear()
		resolve_attack(selected, u)
		selected = null

func take_turn_for(enemy: Node):
	# find target
	var target = null
	for u in _all_units:
		if u.allied:
			target = u
	# The player has lost :(
	# FIXME: handle this
	if target == null:
		return
	var enemy_pos = $TerrainTileMap.world_to_map(enemy.position)
	var target_pos = $TerrainTileMap.world_to_map(target.position)
	
	# move towards target
	# TODO: break out into something called "move_toward"
	var bgrid = get_blocking_grid()
	bgrid[target_pos.x][target_pos.y] = false
	var path_to_player = pathing.get_shortest_path(
		enemy_pos, 
		target_pos, 
		bgrid
	)
	if path_to_player.size() >= 3:
		var move_to_index = min(path_to_player.size() - 2, enemy.remaining_movement)
		move_unit(enemy, path_to_player[move_to_index])
		yield(enemy, "movement_complete")
	
	# try to attack
	var attacked = resolve_attack(enemy, target)
	if attacked:
		yield(self, "lock_released")
	emit_signal("enemy_turn_complete")

func end_turn():
	_locked = true
	$UIOverlayTileMap.clear()
	selected = null
	for u in _all_units:
		if !u.allied:
			var fn_state = take_turn_for(u)
			if fn_state != null:
				yield(self, "enemy_turn_complete")
	for u in _all_units:
		u.end_turn()
	_locked = false
