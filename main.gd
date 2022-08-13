extends Node

var main_menu_screen = preload("res://screens/main_menu/MainMenu.tscn")
var party_management_screen = preload("res://screens/party_management/PartyManagement.tscn")
var dungeon_screen = preload("res://screens/dungeon/Dungeon.tscn")
var reward_menu_screen = preload("res://screens/reward_menu/RewardMenu.tscn")

var paladin = preload("res://units/Paladin/Paladin.tscn")
var archer = preload("res://units/Archer/Archer.tscn")

var main_music = preload("res://audio/music/dugneon.mp3")
var battle_music = preload("res://audio/music/battle.mp3")

var _current_screen = null

var _party = []
onready var _level_generator = LevelGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicAudioStreamPlayer.play()
	_party = [paladin.instance(), archer.instance()]
	
	_current_screen = main_menu_screen.instance()
	_current_screen.connect("play_button_pressed", self, "_play_game")
	add_child(_current_screen)

func _switch_to_party_management(ground_item):
	remove_child(_current_screen)
	_current_screen.queue_free()
	_current_screen = party_management_screen.instance()
	_current_screen.connect("party_management_completed", self, "_on_PartyManagemend_completed")
	add_child(_current_screen)
	_current_screen.initialize(
		_party,
		ground_item
	)

func _switch_to_reward_menu():
	remove_child(_current_screen)
	_current_screen.queue_free()
	_current_screen = reward_menu_screen.instance()
	add_child(_current_screen)
	_current_screen.connect("item_chosen", self, "_on_RewardMenu_item_chosen")
	_current_screen.initialize(
		_level_generator.get_reward_items()
	)

func _play_game():
	$MusicAudioStreamPlayer.stream = battle_music
	$MusicAudioStreamPlayer.play()
	
	var last_scene = _current_screen
	remove_child(last_scene)
	last_scene.queue_free()
	_current_screen = dungeon_screen.instance()
	add_child(_current_screen)
	for unit in _party:
		unit.between_game_reset()
		var parent = unit.get_parent()
		if parent != null:
			parent.remove_child(unit)
	_current_screen.intialize(_party, _level_generator.get_enemies())
	_current_screen.connect("battle_completed", self, "_on_Dungeon_battle_completed")

func _on_RewardMenu_item_chosen(item):
	_switch_to_party_management(item)

func _on_Dungeon_battle_completed():
	_switch_to_reward_menu()

func _on_PartyManagemend_completed():
	_level_generator.increase_depth()
	_play_game()
