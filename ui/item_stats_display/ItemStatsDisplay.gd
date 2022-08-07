extends Control

var health_stat_display = preload("res://ui/stat_display/HealthStatDisplay.tscn")
var movement_stat_display = preload("res://ui/stat_display/MovementStatDisplay.tscn")
var range_stat_display = preload("res://ui/stat_display/RangeStatDisplay.tscn")
var damage_stat_display = preload("res://ui/stat_display/DamageStatDisplay.tscn")

var _stats_children = []

var stat_to_display = {
	"damage": damage_stat_display,
	"movement": movement_stat_display,
	"health": health_stat_display,
	"attack_range": range_stat_display
}

func set_item(item):
	$ItemDisplay.set_item(item)
	display_stats(item)

func display_stats(item):
	for c in _stats_children:
		remove_child(c)
		c.queue_free()
	_stats_children = []
	var left_margin = 13
	var i = 0
	for stat in item.stats:
		var stat_display = stat_to_display[stat].instance()
		stat_display.set_value(item.stats[stat])
		add_child(stat_display)
		stat_display.rect_position = Vector2(13 + i * left_margin, 1)
		stat_display.mouse_filter = MOUSE_FILTER_PASS
		_stats_children.push_back(stat_display)
		i += 1
