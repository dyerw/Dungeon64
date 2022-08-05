extends TileMap

func draw_path(tiles: Array):
	clear()
	if tiles.size() == 0:
		return
	for tile in tiles:
		set_cellv(tile, 0)
	update_bitmask_region()
	set_cellv(tiles[0], -1)
