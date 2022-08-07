extends Control

func display_unit(unit):
	$DamageStatDisplay.set_value(unit.get_damage())
	_color_bonus($DamageStatDisplay, unit.get_base_damage(), unit.get_damage())
	$HealthStatDisplay.set_value(unit.get_max_health())
	_color_bonus($HealthStatDisplay, unit.get_base_max_health(), unit.get_max_health())
	$MovementStatDisplay.set_value(unit.get_movement())
	_color_bonus($MovementStatDisplay, unit.get_base_movement(), unit.get_movement())
	$RangeStatDisplay.set_value(unit.get_attack_range())
	_color_bonus($RangeStatDisplay, unit.get_base_attack_range(), unit.get_attack_range())

func _color_bonus(display, base, modified):
	if base < modified:
		display.color_green()
	if base > modified:
		display.color_red()
	if base == modified:
		display.color_white()
