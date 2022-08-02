extends Node2D

export var human_sprite: PackedScene
export var selected_scene: PackedScene

var _grid_to_unit = []
var selected = null

func _initialize_grid():
	_grid_to_unit.resize(8)
	for i in _grid_to_unit.size():
		var a = []
		a.resize(8)
		_grid_to_unit[i] = a

# Called when the node enters the scene tree for the first time.
func _ready():
	_initialize_grid()
	
	var h = human_sprite.instance()
	add_child(h)
	move_unit(h, Vector2(3,3))

func move_unit(entity: Node2D, pos: Vector2):
	var old_position = $TerrainTileMap.world_to_map(entity.position)
	_grid_to_unit[old_position.x][old_position.y] = null
	
	entity.position = $TerrainTileMap.map_to_world(pos)
	_grid_to_unit[pos.x][pos.y] = entity

func get_unit(pos: Vector2) -> Node2D:
	return _grid_to_unit[pos.x][pos.y]

func select_unit(unit: Node2D):
	selected = unit
	
	var unit_grid_pos = $TerrainTileMap.world_to_map(unit.position)
	var accessible_tiles = PoolVector2Array()
	for x in range(8):
		for y in range(8):
			var v = Vector2(x, y)
			if v.distance_to(unit_grid_pos) <= unit.movement:
				accessible_tiles.push_back(v)
	$UIOverlayTileMap.highlight_tiles(accessible_tiles)

func _on_TileMap_tile_left_clicked(pos: Vector2):
	var u = get_unit(pos)
	if u != null:
		select_unit(u)

func _on_TileMap_tile_right_clicked(pos: Vector2):
	if selected != null:
		move_unit(selected, pos)
		$UIOverlayTileMap.clear()
		selected = null
