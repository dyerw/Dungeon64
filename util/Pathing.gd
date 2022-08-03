class_name Pathing

func get_reachable_positions(start_pos: Vector2, moves: int, grid_to_blocked: Array, grid_to_unit: Array) -> PoolVector2Array:
	var reachable_tiles = PoolVector2Array()
	for x in range(8):
		for y in range(8):
			if !grid_to_blocked[x][y] and grid_to_unit[x][y] == null:
				if is_reachable(start_pos, Vector2(x, y), moves, grid_to_blocked, grid_to_unit):
					reachable_tiles.push_back(Vector2(x, y))
	return reachable_tiles

func is_reachable(start_pos: Vector2, end_pos: Vector2, moves: int, grid_to_blocked: Array, grid_to_unit: Array) -> bool:
	var dist_to_end = get_shortest_path(start_pos, end_pos, grid_to_blocked, grid_to_unit).size() 
	return dist_to_end <= moves + 1 and dist_to_end > 0

func get_shortest_path(start_pos: Vector2, end_pos: Vector2, grid_to_blocked: Array, grid_to_unit: Array) -> PoolVector2Array:
	var aStar = AStar2D.new()
	for x in range(8):
		for y in range(8):
			var pos = Vector2(x, y)
			aStar.add_point(id_for_pos(pos), pos)
	for x in range(8):
		for y in range(8):
			var pos = Vector2(x, y)
			for direction in [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]:
				var neighbor = pos + direction
				if is_open_tile(neighbor, grid_to_blocked, grid_to_unit):
					aStar.connect_points(id_for_pos(neighbor), id_for_pos(pos), true)
	return aStar.get_point_path(id_for_pos(start_pos), id_for_pos(end_pos))

func id_for_pos(pos: Vector2):
	return 8 * pos.y + pos.x

static func is_open_tile(neighbor: Vector2, grid_to_blocked: Array, grid_to_unit: Array) -> bool:
	return !(neighbor.x < 0 or neighbor.y < 0 or neighbor.x > 7 or neighbor.y > 7 or grid_to_blocked[neighbor.x][neighbor.y] or grid_to_unit[neighbor.x][neighbor.y] != null)
