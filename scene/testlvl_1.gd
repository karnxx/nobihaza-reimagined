extends Node2D 
var astar_grid = AStarGrid2D.new()
@onready var tile_map: TileMap = $TileMap
const HORROR1 = preload("res://assets/music/dark-horror-ambience-for-mystical-scenes-179447.mp3")

var current_music = [HORROR1]


func _ready() -> void: 

	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""

	$door1.spawnwn = "corridor_spawn_1"
	$AudioStreamPlayer.stream = current_music.pick_random()
	$AudioStreamPlayer.play()
	
	var t := Timer.new()
	t.wait_time = randi_range(13, 30)
	t.autostart = true
	t.timeout.connect(flicker_ambience)
	add_child(t)

func flicker_ambience():
	if $AudioStreamPlayer2.playing:
		return
	if randi() % 5 == 0:
		$AudioStreamPlayer2.stream = preload("res://assets/music/flickering-neon-316717.mp3")
		$AudioStreamPlayer2.play()
