class_name Pathing

func get_reachable_positions(start_pos: Vector2, moves: int, blocked_tiles: PoolVector2Array) -> PoolVector2Array:
	var reachable_tiles = PoolVector2Array()
	for x in range(8):
		for y in range(8):
			var v = Vector2(x, y)
			if !(v in blocked_tiles):
				if is_reachable(start_pos, v, moves, blocked_tiles):
					reachable_tiles.push_back(v)
	return reachable_tiles

func is_reachable(start_pos: Vector2, end_pos: Vector2, moves: int, blocked_tiles: PoolVector2Array) -> bool:
	var path = get_shortest_path(start_pos, end_pos, blocked_tiles)
	var dist_to_end = path.size() 
	return dist_to_end <= moves + 1 and dist_to_end > 0

func get_shortest_path(start_pos: Vector2, end_pos: Vector2, blocked_tiles: PoolVector2Array) -> PoolVector2Array:
	var aStar = AStar2D.new()
	for x in range(8):
		for y in range(8):
			var pos = Vector2(x, y)
			if is_open_tile(pos, blocked_tiles) or pos == start_pos:
				aStar.add_point(id_for_pos(pos), pos)
	for x in range(8):
		for y in range(8):
			var pos = Vector2(x, y)
			if is_open_tile(pos, blocked_tiles) or pos == start_pos:
				for direction in [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)]:
					var neighbor = pos + direction
					if is_open_tile(neighbor, blocked_tiles):
						aStar.connect_points(id_for_pos(neighbor), id_for_pos(pos), true)
	return aStar.get_point_path(id_for_pos(start_pos), id_for_pos(end_pos))

func id_for_pos(pos: Vector2):
	return 8 * pos.y + pos.x

static func is_open_tile(pos: Vector2, blocked_tiles: PoolVector2Array) -> bool:
	return !(pos.x < 0 or pos.y < 0 or pos.x > 7 or pos.y > 7 or (pos in blocked_tiles))
