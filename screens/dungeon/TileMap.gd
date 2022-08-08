extends TileMap

signal tile_left_clicked
signal tile_right_clicked

const MAP_HEIGHT = 8
const MAP_WIDTH = 8

enum TERRAIN_TYPE {
	WALL,
	FLOOR
}

var _terrain_blocking = {
	TERRAIN_TYPE.WALL: true,
	TERRAIN_TYPE.FLOOR: false
}

func _inbounds(v: Vector2) -> bool:
	return v.x > 0 and v.x < 7 and v.y > 0 and v.y < 7

func _input(event):
	if event is InputEventMouseButton:
		var tile = world_to_map(event.position)
		if _inbounds(tile):
			if event.button_index == BUTTON_LEFT and event.pressed:
				emit_signal("tile_left_clicked", tile)
			if event.button_index == BUTTON_RIGHT and event.pressed:
				emit_signal("tile_right_clicked", tile)

func get_terrain(grid_pos: Vector2):
	var cell = get_cell(grid_pos.x, grid_pos.y)
	var tile_name = tile_set.tile_get_name(cell)
	if "Wall" in tile_name:
		return TERRAIN_TYPE.WALL
	if "Floor" in tile_name:
		return TERRAIN_TYPE.FLOOR

func get_blocking_tiles() -> PoolVector2Array:
	var blocking_tiles = PoolVector2Array()
	for x in range(MAP_WIDTH):
		for y in range(MAP_HEIGHT):
			var v = Vector2(x, y)
			if _terrain_blocking[get_terrain(v)]:
				blocking_tiles.push_back(v)
	return blocking_tiles
