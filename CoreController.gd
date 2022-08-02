extends Node2D

export var human: PackedScene
export var orc: PackedScene

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
	
	var h = human.instance()
	var o = orc.instance()
	add_child(o)
	add_child(h)
	h.position = $TerrainTileMap.map_to_world(Vector2(1,1))
	update_grid(h, Vector2(1,1))
	update_grid(o, Vector2(3,3))
	o.position = $TerrainTileMap.map_to_world(Vector2(3,3))

func update_grid(entity: Node2D, pos: Vector2):
	var old_position = $TerrainTileMap.world_to_map(entity.position)
	_grid_to_unit[old_position.x][old_position.y] = null
	_grid_to_unit[pos.x][pos.y] = entity

func move_unit(entity: Node2D, pos: Vector2):
	update_grid(entity, pos)
	entity.move($TerrainTileMap.map_to_world(pos), pos.distance_to($TerrainTileMap.world_to_map(entity.position)))

func get_unit(pos: Vector2) -> Node2D:
	return _grid_to_unit[pos.x][pos.y]

func select_unit(unit: Node2D):
	selected = unit
	var unit_grid_pos = $TerrainTileMap.world_to_map(unit.position)
	$UIOverlayTileMap.highlight_range(unit_grid_pos, unit.remaining_movement)

func _on_TileMap_tile_left_clicked(pos: Vector2):
	var u = get_unit(pos)
	if u != null:
		select_unit(u)

func _on_TileMap_tile_right_clicked(pos: Vector2):
	if selected != null:
		move_unit(selected, pos)
		$UIOverlayTileMap.clear()
		selected = null
