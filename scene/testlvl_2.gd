extends Node2D 
const HORROR1 = preload("res://assets/music/dark-horror-ambience-for-mystical-scenes-179447.mp3")

var current_music = [HORROR1]

func _ready() -> void: 

	
	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""
	$walkdoor.spawnwn = "spawn1"
	$AudioStreamPlayer.stream = current_music.pick_random()	
	$AudioStreamPlayer.play()
