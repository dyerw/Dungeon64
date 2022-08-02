extends TileMap


func _ready():
	pass # Replace with function body.

func highlight_tiles(positions: PoolVector2Array):
	clear()
	for p in positions:
		set_cell(p.x, p.y, 0)
