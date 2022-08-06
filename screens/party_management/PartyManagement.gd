extends Control

var _unit_index: int = 0
var _units = []

var archer_frames = preload("res://resources/frames/ArcherFrames.tres")
var human_frames = preload("res://resources/frames/HumanFrames.tres")

var type_to_frames = {
	"Human": human_frames,
	"Archer": archer_frames
}

func initialize(units):
	_units = units
	_select_index(0)

func _select_index(i):
	if i > _units.size() - 1:
		print("PartyManagement:: You fucked up your modulo math, bud")
		return
	_unit_index = i
	$Panel/BlockStatDisplay.display_unit(_units[i])
	$Panel/UnitDisplay.frames = type_to_frames[_units[i].unit_name]


func _on_RightButton_pressed():
	var new_idx = (_unit_index + 1) % _units.size()
	_select_index(new_idx)


func _on_LeftButton_pressed():
	var new_idx = (_unit_index - 1) % _units.size()
	_select_index(new_idx)
