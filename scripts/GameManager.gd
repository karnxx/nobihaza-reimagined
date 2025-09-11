extends Node
var tile_size = 16
var next_spawn: String = "" 
var reserved_tiles: = {}
var need_to_release

func change_scene(sceen, spawn) -> void:
	next_spawn = spawn
	InventoryManager.save_inv()
	SceneManager.change_scene(sceen, {"pattern_enter": "squares", "pattern_leave": "squares", "color" : Color('#ffffff')})

func reserve_tile(cell: Vector2i, actor: Node) -> bool:
	if reserved_tiles.has(cell) or need_to_release == cell:
		return false 
	reserved_tiles[cell] = actor
	return true

func release_tile(cell: Vector2i) -> void:
	if reserved_tiles.has(cell):
		reserved_tiles.erase(cell)
		need_to_release = cell

func is_tile_free(cell: Vector2i) -> bool:
	return not reserved_tiles.has(cell)

func get_actor_at(cell: Vector2i) -> Node:
	if reserved_tiles.has(cell):
		return reserved_tiles[cell]
	return null
