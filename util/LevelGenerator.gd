class_name LevelGenerator
extends Reference

var orc = preload("res://units/Orc/Orc.tscn")

# Depth is how far into dungeon you currently are,
# as it increases enemies get more difficult and
# rewards get stronger
var _depth = 0
var item_type_to_stat = {
	"boot": "movement",
	"helmet": "max_health",
	"sword": "damage"
}

var rarities = ["common", "uncommon", "rare"]

var all_possible_modifiers = ["max_health", "movement", "damage", "attack_range"] # TODO: Add range somehow

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
	var first_item = generate_item(item_type_to_stat.keys(), 1)
	result.append(first_item)
	var second_item_types = item_type_to_stat.keys()
	ArrayUtil.remove_value(second_item_types, first_item["type"])
	result.append(generate_item(second_item_types, 2))
	return result

func increase_depth():
	_depth += 1

func decide_item():
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
	#else:
		#table = generate_item()
	var index = rng.randi_range(0, table.size()-1)
	
	return table[index]

func generate_item(item_types, tier):
	var item_type = ArrayUtil.choose(item_types)
	var item = {
		"type": item_type, 
		"rarity": rarities[tier],
		"stats": {
			item_type_to_stat[item_type]: 1
		}
	}
	for i in tier:
		var modifier = ArrayUtil.choose(all_possible_modifiers)
		if modifier in item["stats"]:
			item["stats"][modifier] += 1
		else:
			item["stats"][modifier] = 1
			
	return item
