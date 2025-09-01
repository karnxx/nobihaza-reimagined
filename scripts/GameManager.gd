extends Node
var tile_size = 16
var next_spawn: String = "" 

func change_scene(sceen, spawn) -> void:
	next_spawn = spawn
	get_tree().call_deferred("change_scene_to_file", sceen)
