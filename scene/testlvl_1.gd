extends Node2D 
var astar_grid = AStarGrid2D.new()
@onready var tile_map: TileMap = $TileMap

func _ready() -> void: 

	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""

	$door1.spawnwn = "corridor_spawn_1"
	
