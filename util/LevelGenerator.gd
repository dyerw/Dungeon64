class_name LevelGenerator
extends Reference

var orc = preload("res://units/Orc/Orc.tscn")

# Depth is how far into dungeon you currently are,
# as it increases enemies get more difficult and
# rewards get stronger
var _depth = 0

var common_item_table = [
	{
		"type": "boot", 
		"rarity": "common",
		"stats": {
			"movement": 1
		}
	},
	{
		"type": "sword", 
		"rarity": "common",
		"stats": {
			"damage": 1
		}
	}
]

var uncommon_item_table = [
	{
		"type": "helmet", 
		"rarity": "uncommon",
		"stats": {
			"max_health": 1,
			"movement": 1
		}
	}
]

var rare_item_table = [
	{
		"type": "helmet", 
		"rarity": "rare",
		"stats": {
			"max_health": 2,
			"movement": 1
		}
	}
]
var rare_threshold = 105
var uncommon_threshold = 75

func get_enemies():
	var enemies = []
	for i in _depth * 2 + 1:
		enemies.push_back(orc.instance())
	return enemies

func get_reward_items():
	var result = []
	result.append(decide_item())
	result.append(decide_item())
	return result

func increase_depth():
	_depth += 1

func decide_item() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var raw_roll = rng.randi_range(0, 100)
	var roll_modifier = _depth * 5
	var roll = raw_roll+roll_modifier
	print("Just rolled for an item - raw ", raw_roll, "modifier ", roll_modifier, "total ", roll)
	var table
	if roll > rare_threshold:
		table = rare_item_table
	elif roll > uncommon_threshold:
		table = uncommon_item_table
	else:
		table = common_item_table
	var index = rng.randi_range(0, table.size()-1)
	
	return table[index]
