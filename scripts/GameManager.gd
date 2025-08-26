extends Node

var next_spawn: String = "" 

func change_scene(sceen, spawn) -> void:
	next_spawn = spawn
	get_tree().change_scene_to_file(sceen)
