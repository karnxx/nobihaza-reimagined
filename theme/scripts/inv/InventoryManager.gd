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
var active_cutscene :String
var puzzles_done: Array = []
var enemies_killed: Array = []
var items_collected: Array = []
var cutscenes_done: Array = []
var plr = null
var facing = ""
var cutscene_freeze := false
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
		if inv[i] != null and inv[i]["type"] == item["type"] and inv[i]["effect"] == item["effect"] and inv[i]['name'] == item['name']:
			inv[i]["qty"] += item["qty"]
			inv_upd.emit()
			return true
	for i in range(inv.size()):
		if inv[i] == null:
			inv[i] = item
			inv_upd.emit()
			return true
	return false


func remove_item(namde):
	for i in range(inv.size()):
		if inv[i] != null and inv[i]["name"] == namde :
			inv[i]["qty"] -= 1
			if inv[i]["qty"] <= 0:
				inv[i] = null
			inv_upd.emit()
			print(inv)
			return true
	print('adad')
	return false

func increase_inv_total(slots):
	inv.resize(inv.size() + slots)
	inv_upd.emit()

func add_gun(gun, idnv) -> bool:
	idnv.append(gun)
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
		facing = plr.facing
	
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
		plr.facing = facing

func mark_item_collected(id: String) -> void:
	if id != "" and id not in items_collected:
		items_collected.append(id)

func is_item_collected(id: String) -> bool:
	return id != "" and id in items_collected

func mark_enemy_killed(id: String) -> void:
	if id != "" and id not in enemies_killed:
		enemies_killed.append(id)

func is_enemy_dead(id: String) -> bool:
	return id != "" and id in enemies_killed

func mark_cutscene_done(id: String) -> void:
	if id != "" and id not in cutscenes_done:
		cutscenes_done.append(id)

func is_cutscene_done(id: String) -> bool:
	return id != "" and id in cutscenes_done

func set_freeze(value: bool, source) -> void:
	if cutscene_freeze and value == false:
		print("Ignored unfreeze from ", source, " (cutscene running)")
		return

	freeze = value
	print("freeze =", freeze, " source=", source)
	
func start_cutscene():
	cutscene_freeze = true
	set_freeze(true, "cutscene")
	
func end_cutscene():
	cutscene_freeze = false
	set_freeze(false, "cutscene")
