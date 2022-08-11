extends Node

var main_menu_screen = preload("res://screens/main_menu/MainMenu.tscn")
var party_management_screen = preload("res://screens/party_management/PartyManagement.tscn")
var dungeon_screen = preload("res://screens/dungeon/Dungeon.tscn")
var reward_menu_screen = preload("res://screens/reward_menu/RewardMenu.tscn")

var paladin = preload("res://units/Paladin/Paladin.tscn")
var archer = preload("res://units/Archer/Archer.tscn")

var _party = []
onready var _level_generator = LevelGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_party = [paladin.instance(), archer.instance()]
	
	var scene = main_menu_screen.instance()
	scene.connect("play_button_pressed", self, "_play_game")
	add_child(scene)

func _switch_to_party_management(ground_item):
	print("_party right before removing reward: ", _party)
	remove_child(get_child(0))
	var scene = party_management_screen.instance()
	scene.connect("party_management_completed", self, "_on_PartyManagemend_completed")
	print("_party right before management: ", _party)
	add_child(scene)
	scene.initialize(
		_party,
		ground_item
	)

func _switch_to_reward_menu():
	print("_party right before removing game: ", _party)
	remove_child(get_child(0))
	print("_party right after removing game: ", _party)
	var scene = reward_menu_screen.instance()
	add_child(scene)
	scene.connect("item_chosen", self, "_on_RewardMenu_item_chosen")
	scene.initialize(
		_level_generator.get_reward_items()
	)

func _play_game():
	var last_scene = get_child(0)
	remove_child(last_scene)
	var scene = dungeon_screen.instance()
	add_child(scene)
	for unit in _party:
		unit.between_game_reset()
		var parent = unit.get_parent()
		if parent != null:
			parent.remove_child(unit)
	scene.intialize(_party, _level_generator.get_enemies())
	scene.connect("battle_completed", self, "_on_Dungeon_battle_completed")

func _on_RewardMenu_item_chosen(item):
	_switch_to_party_management(item)

func _on_Dungeon_battle_completed():
	_switch_to_reward_menu()

func _on_PartyManagemend_completed():
	_level_generator.increase_depth()
	_play_game()
