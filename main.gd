extends Node

var main_menu_screen = preload("res://screens/main_menu/MainMenu.tscn")
var party_management_screen = preload("res://screens/party_management/PartyManagement.tscn")
var dungeon_screen = preload("res://screens/dungeon/Dungeon.tscn")

var human = preload("res://units/Human/Human.tscn")
var archer = preload("res://units/Archer/Archer.tscn")

var _party = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_party = [human.instance(), archer.instance()]
	
	var scene = main_menu_screen.instance()
	scene.connect("play_button_pressed", self, "_play_game")
	add_child(scene)

func _play_game():
	print("play game!")
	remove_child(get_child(0))
	var scene = party_management_screen.instance()
	add_child(scene)
	scene.initialize(_party)
