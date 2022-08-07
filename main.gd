extends Node

var main_menu_screen = preload("res://screens/main_menu/MainMenu.tscn")
var party_management_screen = preload("res://screens/party_management/PartyManagement.tscn")
var dungeon_screen = preload("res://screens/dungeon/Dungeon.tscn")
var reward_menu_screen = preload("res://screens/reward_menu/RewardMenu.tscn")

var human = preload("res://units/Human/Human.tscn")
var archer = preload("res://units/Archer/Archer.tscn")

var _party = []

# Called when the node enters the scene tree for the first time.
func _ready():
	_party = [human.instance(), archer.instance()]
	_party[0].equipped_item = {
		"type": "sword", 
		"rarity": "common",
		"stats": {
			"damage": 1
		}
	}
	
	var scene = main_menu_screen.instance()
	scene.connect("play_button_pressed", self, "_switch_to_party_management")
	#scene.connect("play_button_pressed", self, "_play_game")
	add_child(scene)

func _switch_to_party_management():
	remove_child(get_child(0))
	var scene = party_management_screen.instance()
	add_child(scene)
	scene.initialize(
		_party,
		{
			"type": "boot", 
			"rarity": "uncommon",
			"stats": {
				"movement": 1,
				"attack_range": 2
			}
		}
	)

func _play_game():
	print("play game!")
	remove_child(get_child(0))
	var scene = reward_menu_screen.instance()
	scene.connect("item_chosen", self, "_on_RewardMenu_item_chosen")
	add_child(scene)
	scene.initialize([
		{
			"type": "boot", 
			"rarity": "uncommon",
			"stats": {
				"movement": 1,
				"attack_range": 2
			}
		},
		{
			"type": "sword", 
			"rarity": "common",
			"stats": {
				"damage": 1
			}
		}
	])

func _on_RewardMenu_item_chosen(item):
	print(item)
