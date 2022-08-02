extends TileMap


func _ready():
	pass # Replace with function body.

func highlight_tiles(positions: PoolVector2Array):
	clear()
	for p in positions:
		set_cell(p.x, p.y, 0)

func highlight_range(pos: Vector2, r: int):
	clear()
	for x in range(8):
		for y in range(8):
			var v = Vector2(x, y)
			if v.distance_to(pos) <= r:
				set_cell(x, y, 0)
