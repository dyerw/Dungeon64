extends Node2D

export var human: PackedScene
export var orc: PackedScene

var pathing = Pathing.new()
var _grid_to_unit = []
var _all_units = []
var _grid_to_blocked = []
var selected = null

var locked = false

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
	
	_all_units.push_back(o)

	_all_units.push_back(h)
	
	for u in _all_units:
		u.connect("died", self, "_on_Unit_died")

func _on_Unit_died(unit: Node2D):
	_all_units.remove(_all_units.find(unit))
	clear_unit_from_grid(unit)

func clear_unit_from_grid(unit: Node2D):
	var old_position = $TerrainTileMap.world_to_map(unit.position)
	_grid_to_unit[old_position.x][old_position.y] = null

func update_grid(entity: Node2D, pos: Vector2):
	clear_unit_from_grid(entity)
	_grid_to_unit[pos.x][pos.y] = entity

func move_unit(entity: Node2D, pos: Vector2):
	update_grid(entity, pos)
	locked = true
	entity.move($TerrainTileMap.map_to_world(pos), pos.distance_to($TerrainTileMap.world_to_map(entity.position)))
	yield(entity, "move_complete")
	locked = false

func get_unit(pos: Vector2) -> Node2D:
	return _grid_to_unit[pos.x][pos.y]

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
	var reachable = pathing.get_reachable_positions(
		$TerrainTileMap.world_to_map(unit.position),
		unit.remaining_movement,
		_grid_to_blocked,
		_grid_to_unit
	)
	$UIOverlayTileMap.highlight_tiles_moveable(reachable)

func resolve_attack(attacker: Node2D, defender: Node2D):
	if distance_between_units(attacker, defender) <= attacker.attack_range:
		locked = true
		attacker.attack()
		defender.take_damage(attacker.damage)
		yield(attacker, "attack_complete")
		locked = false

func can_move(unit: Node2D, to: Vector2):
	return pathing.is_reachable($TerrainTileMap.world_to_map(unit.position), to, unit.remaining_movement, _grid_to_blocked, _grid_to_unit)

func _on_TileMap_tile_left_clicked(pos: Vector2):
	if locked:
		return
	
	if pos == Vector2(0,0):
		end_turn()
	
	var u = get_unit(pos)
	if u != null and u.allied:
		select_unit(u)

func _on_TileMap_tile_right_clicked(pos: Vector2):
	if locked:
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

func end_turn():
	locked = true
	$UIOverlayTileMap.clear()
	selected = null
	for u in _all_units:
		if u.allied:
			u.end_turn()
	locked = false
