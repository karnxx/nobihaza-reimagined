extends Node

signal inv_upd
var freeze = false
var inv = []
var gun_inv = []
var plr : Node = null

func _ready() -> void:
	inv.resize(30)

func add_item(item):
	for i in range(inv.size()):
		if inv[i] != null and inv[i]["type"] == item["type"] and inv[i]["effect"] == item["effect"]:
			inv[i]["qty"] += item["qty"]
			inv_upd.emit()
			print("Stacked:", inv[i])
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
	print(gun_inv)
	return true

func remove_gun(damage) -> bool:
	for i in range(gun_inv.size()):
		if gun_inv[i] != null and gun_inv[i]["damage"] == damage:
			gun_inv.remove_at(i)
			inv_upd.emit()
			return true
	return false

func set_player(player):
	plr = player
