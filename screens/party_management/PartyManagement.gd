extends Control

var _unit_index: int = 0
var _units = []
var _ground_item

var archer_frames = preload("res://resources/frames/ArcherFrames.tres")
var human_frames = preload("res://resources/frames/HumanFrames.tres")
var paladin_frames = preload("res://resources/frames/PaladinFrames.tres")
var wizard_frames = preload("res://resources/frames/WizardFrames.tres")

enum TabState { ITEM, STATS }

onready var stats_menu = get_node("%StatsMenu")
onready var item_menu = get_node("%ItemMenu")
onready var stats_button = get_node("%StatsButton")
onready var item_button = get_node("%ItemButton")
onready var stat_display = get_node("%BlockStatDisplay")

onready var held_item_slot = get_node("%HeldItemSlot")
onready var ground_item_slot = get_node("%GroundItemSlot")

signal party_management_completed

var _selected_tab = null

var type_to_frames = {
	"Human": human_frames,
	"Archer": archer_frames,
	"Paladin": paladin_frames,
	"Wizard": wizard_frames
}

func _ready():
	_select_tab(TabState.ITEM)

func initialize(units, ground_item):
	_units = units
	_select_index(0)
	_ground_item = ground_item
	ground_item_slot.set_item(ground_item)

func _select_tab(tab):
	if tab == TabState.ITEM:
		stats_menu.visible = false
		item_menu.visible = true
		item_button.disabled = true
		stats_button.disabled = false
	else:
		stats_menu.visible = true
		item_menu.visible = false
		item_button.disabled = false
		stats_button.disabled = true

func _select_index(i):
	if i > _units.size() - 1:
		print("PartyManagement:: You fucked up your modulo math, bud")
		return
	_unit_index = i
	stat_display.display_unit(_units[i])
	held_item_slot.set_item(_units[i].equipped_item)
	$Panel/UnitDisplay.frames = type_to_frames[_units[i].unit_name]


func _on_RightButton_pressed():
	var new_idx = (_unit_index + 1) % _units.size()
	_select_index(new_idx)


func _on_LeftButton_pressed():
	var new_idx = (_unit_index - 1) % _units.size()
	_select_index(new_idx)


func _on_StatsButton_pressed():
	_select_tab(TabState.STATS)


func _on_ItemButton_pressed():
	_select_tab(TabState.ITEM)


func _on_ItemSwapButton_pressed():
	var unit = _units[_unit_index]
	var tmp = unit.equipped_item
	unit.equipped_item = _ground_item
	_ground_item = tmp
	held_item_slot.set_item(unit.equipped_item)
	ground_item_slot.set_item(_ground_item)
	stat_display.display_unit(unit)


func _on_EnterDungeonButton_pressed():
	emit_signal("party_management_completed")
