extends Control

var boot_texture = preload("res://images/items/boot.png")
var sword_texture = preload("res://images/items/sword.png")

var common_background_texture = preload("res://images/items/common.png")
var uncommon_background_texture = preload("res://images/items/uncommon.png")
var rare_background_texture = preload("res://images/items/rare.png")

var rarity_to_texture = {
	"common": common_background_texture,
	"uncommon": uncommon_background_texture,
	"rare": rare_background_texture
}

var item_to_texture = {
	"boot": boot_texture,
	"sword": sword_texture
}

func set_item(item):
	$RarityBackground.texture = rarity_to_texture[item["rarity"]]
	$ItemImage.texture = item_to_texture[item["type"]]
