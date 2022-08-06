extends Control

func display_unit(unit):
	$DamageStatDisplay.set_value(unit.damage)
	$HealthStatDisplay.set_value(unit.max_health)
	$MovementStatDisplay.set_value(unit.movement)
	$RangeStatDisplay.set_value(unit.attack_range)
