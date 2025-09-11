extends Node

signal inv_upd

var freeze = false

var inv = []
var gun_inv = []
var secondary_inv = []
var armor_inv = []
var utils_inv = []
var primary_gun = null
var secondary_gun = null
var armor = null
var utils = null

var plr = null

func _ready() -> void:
	inv.resize(30)

func set_player(player):
	plr = player
	if primary_gun:
		plr.primary_gun = primary_gun
	if secondary_gun:
		plr.secondary_gun = secondary_gun
	if armor:
		plr.armor = armor
	if utils:
		plr.utils = utils

func add_item(item):
	for i in range(inv.size()):
		if inv[i] != null and inv[i]["type"] == item["type"] and inv[i]["effect"] == item["effect"]:
			inv[i]["qty"] += item["qty"]
			inv_upd.emit()
			return true
	for i in range(inv.size()):
		if inv[i] == null:
			inv[i] = item
			inv_upd.emit()
			return true
	return false

func remove_item(type, effect):
	for i in range(inv.size()):
		if inv[i] != null and inv[i]["type"] == type and inv[i]["effect"] == effect:
			inv[i]["qty"] -= 1
			if inv[i]["qty"] <= 0:
				inv[i] = null
			inv_upd.emit()
			return true
	return false

func increase_inv_total(slots):
	inv.resize(inv.size() + slots)
	inv_upd.emit()

func add_gun(gun) -> bool:
	gun_inv.append(gun)
	inv_upd.emit()
	return true

func remove_gun(damage) -> bool:
	for i in range(gun_inv.size()):
		if gun_inv[i] != null and gun_inv[i]["damage"] == damage:
			gun_inv.remove_at(i)
			inv_upd.emit()
			return true
	return false

func save_inv():
	if plr:
		primary_gun = plr.primary_gun
		secondary_gun = plr.secondary_gun
		armor = plr.armor
		utils = plr.utils
	
	inv = inv.duplicate(true)
	gun_inv = gun_inv.duplicate(true)
	secondary_inv = secondary_inv.duplicate(true)
	armor_inv = armor_inv.duplicate(true)
	utils_inv = utils_inv.duplicate(true)

func load_inv():
	inv = inv.duplicate(true)
	gun_inv = gun_inv.duplicate(true)
	secondary_inv = secondary_inv.duplicate(true)
	armor_inv = armor_inv.duplicate(true)
	utils_inv = utils_inv.duplicate(true)
	
	if plr:
		plr.primary_gun = primary_gun
		plr.secondary_gun = secondary_gun
		plr.armor = armor
		plr.utils = utils
