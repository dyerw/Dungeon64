extends Node

export var main_menu: PackedScene
export var dungeon: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var mm = main_menu.instance()
	mm.connect("play_button_pressed", self, "_play_game")
	add_child(mm)

func _play_game():
	remove_child(get_child(0))
	var d = dungeon.instance()
	add_child(d)
