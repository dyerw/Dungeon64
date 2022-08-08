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
var rare_threshold = 10
var uncommon_threshold = 5

func get_enemies():
	var enemies = []
	for i in _depth * 2 + 1:
		enemies.push_back(orc.instance())
	return enemies

func get_reward_items():
	var result = []
	var first_item = generate_item(item_type_to_stat.keys())
	result.append(first_item)
	var second_item_types = item_type_to_stat.keys()
	ArrayUtil.remove_value(second_item_types, first_item["type"])
	result.append(generate_item(second_item_types))
	return result

func increase_depth():
	_depth += 1

func decide_tier():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var raw_roll = rng.randi_range(1, 5)
	var modified_roll = raw_roll + _depth
	if modified_roll > rare_threshold:
		return 2
	if modified_roll > uncommon_threshold:
		return 1
	return 0

func generate_item(item_types):
	var item_type = ArrayUtil.choose(item_types)
	var tier = decide_tier()
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
