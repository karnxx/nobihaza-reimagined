extends Node2D 

func _ready() -> void: 

	
	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""
	$walkdoor.spawnwn = "spawn1"
