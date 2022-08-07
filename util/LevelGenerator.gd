class_name LevelGenerator
extends Reference

var orc = preload("res://units/Orc/Orc.tscn")

# Depth is how far into dungeon you currently are,
# as it increases enemies get more difficult and
# rewards get stronger
var _depth = 0

func get_enemies():
	var enemies = []
	for i in _depth * 2 + 1:
		enemies.push_back(orc.instance())
	return enemies

func get_reward_items():
	return [
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

func increase_depth():
	_depth += 1
