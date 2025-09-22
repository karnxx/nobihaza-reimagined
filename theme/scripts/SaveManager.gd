extends Node

var save_path := "user://save_slot_%d.json"
func save_game(player: CharacterBody2D, slot: int) -> void:
	var data: Dictionary = {}
	data["player"] = {
		"health": player.current_health,
		"max_health": player.max_health,
		"tp": player.tp,
		"max_tp": player.max_tp,
		"level": player.level,
		"exp": player.current_exp,
		"exp_target": player.exp_target,
		"position": player.global_position,
		"facing": player.facing,
	}
	InventoryManager.save_inv()
	data["inv"] = InventoryManager.inv
	data["gun_inv"] = InventoryManager.gun_inv
	data["primary_gun"] = InventoryManager.primary_gun
	data["secondary_gun"] = InventoryManager.secondary_gun
	data["armor"] = InventoryManager.armor
	data["utils"] = InventoryManager.utils
	data["puzzles_done"] = InventoryManager.puzzles_done
	data["enemies_killed"] = InventoryManager.enemies_killed
	data["items_collected"] = InventoryManager.items_collected
	data["scenes_done"] = InventoryManager.cutscenes_done
	data["scene"] = get_tree().current_scene.scene_file_path
	data["next_spawn"] = GameManager.next_spawn
	var file = FileAccess.open(save_path % slot, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	print("save to", slot)
	

func load_game(slot: int) -> void:
	var path = save_path % slot
	if not FileAccess.file_exists(path):
		print("no slot", slot)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()

	var scene_path = data.get("scene", "")
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame

	var plr = get_tree().current_scene.get_node("plr")

	if "player" in data:
		var p = data["player"]
		plr.current_health = p.get("health", 100)
		plr.max_health = p.get("max_health", 100)
		plr.tp = p.get("tp", 0)
		plr.max_tp = p.get("max_tp", 0)
		plr.level = p.get("level", 1)
		plr.current_exp = p.get("exp", 0)
		plr.exp_target = p.get("exp_target", 100)
		plr.global_position = p.get("position", Vector2.ZERO)
		plr.facing = p.get("facing", "down")

	InventoryManager.inv = data.get("inv", [])
	InventoryManager.gun_inv = data.get("gun_inv", [])
	InventoryManager.primary_gun = data.get("primary_gun", null)
	InventoryManager.secondary_gun = data.get("secondary_gun", null)
	InventoryManager.armor = data.get("armor", null)
	InventoryManager.utils = data.get("utils", null)

	InventoryManager.puzzles_done = data.get("puzzles_done", [])
	InventoryManager.enemies_killed = data.get("enemies_killed", [])
	InventoryManager.items_collected = data.get("items_collected", [])
	InventoryManager.scenes_done = data.get("scenes_done", [])
