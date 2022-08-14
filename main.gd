extends Node

var main_menu_screen = preload("res://screens/main_menu/MainMenu.tscn")
var party_management_screen = preload("res://screens/party_management/PartyManagement.tscn")
var dungeon_screen = preload("res://screens/dungeon/Dungeon.tscn")
var reward_menu_screen = preload("res://screens/reward_menu/RewardMenu.tscn")
var death_screen = preload("res://screens/death/DeathScreen.tscn")

var paladin = preload("res://units/Paladin/Paladin.tscn")
var archer = preload("res://units/Archer/Archer.tscn")
var wizard = preload("res://units/Wizard/Wizard.tscn")

var main_music = preload("res://audio/music/dugneon.mp3")
var battle_music = preload("res://audio/music/battle.mp3")

var _current_screen = null

var _party = []
onready var _level_generator = LevelGenerator.new()

var party_options = [ wizard]

func prep_switch():
	for u in _party:
		if !is_instance_valid(u):
			print("uh oh")
		var parent = u.get_parent()
		if parent != null:
			parent.remove_child(u)

func _ready():
	_switch_to_main_menu()

func _switch_to_main_menu():
	$MusicAudioStreamPlayer.stream = main_music
	$MusicAudioStreamPlayer.play()
	for u in _party:
		u.queue_free()
	_party = []
	for i in 3:
		_party.push_back(ArrayUtil.choose(party_options).instance())
	
	_current_screen = main_menu_screen.instance()
	_current_screen.connect("play_button_pressed", self, "_play_game")
	add_child(_current_screen)

func _switch_to_party_management(ground_item):
	prep_switch()
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
	prep_switch()
	remove_child(_current_screen)
	_current_screen.queue_free()
	_current_screen = reward_menu_screen.instance()
	add_child(_current_screen)
	_current_screen.connect("item_chosen", self, "_on_RewardMenu_item_chosen")
	_current_screen.initialize(
		_level_generator.get_reward_items()
	)

func _play_game():
	prep_switch()
	$MusicAudioStreamPlayer.stream = battle_music
	$MusicAudioStreamPlayer.play()
	
	var last_scene = _current_screen
	remove_child(last_scene)
	print(_party)
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

func _switch_to_death_screen():
	prep_switch()
	remove_child(_current_screen)
	_current_screen.queue_free()
	_current_screen = death_screen.instance()
	_current_screen.initialize(_level_generator.depth)
	_current_screen.connect("death_screen_closed", self, "_on_DeathScreen_closed")
	add_child(_current_screen)
	

func _on_RewardMenu_item_chosen(item):
	_switch_to_party_management(item)

func _on_Dungeon_battle_completed(victory):
	if victory:
		_switch_to_reward_menu()
	else:
		_switch_to_death_screen()

func _on_PartyManagemend_completed():
	_level_generator.increase_depth()
	_play_game()

func _on_DeathScreen_closed():
	_level_generator.depth = 0
	_switch_to_main_menu()

func _input(event):
	if event is InputEventKey and event.scancode == KEY_M:
		$MusicAudioStreamPlayer.stop()

