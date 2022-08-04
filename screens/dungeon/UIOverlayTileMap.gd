extends TileMap


func _ready():
	pass # Replace with function body.

func highlight_tiles_moveable(positions: PoolVector2Array):
	for p in positions:
		set_cell(p.x, p.y, 0)

func highlight_tiles_attackable(positions: PoolVector2Array):
	for p in positions:
		set_cell(p.x, p.y, 1)
