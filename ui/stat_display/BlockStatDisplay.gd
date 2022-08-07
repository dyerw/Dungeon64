extends Control

func display_unit(unit):
	var stats = unit.get_modified_stats()
	$DamageStatDisplay.set_value(stats["damage"])
	_color_bonus($DamageStatDisplay, unit.damage, stats["damage"])
	$HealthStatDisplay.set_value(stats["max_health"])
	_color_bonus($HealthStatDisplay, unit.max_health, stats["max_health"])
	$MovementStatDisplay.set_value(stats["movement"])
	_color_bonus($MovementStatDisplay, unit.movement, stats["movement"])
	$RangeStatDisplay.set_value(stats["attack_range"])
	_color_bonus($RangeStatDisplay, unit.attack_range, stats["attack_range"])

func _color_bonus(display, base, modified):
	if base < modified:
		display.color_green()
	if base > modified:
		display.color_red()
	if base == modified:
		display.color_white()
