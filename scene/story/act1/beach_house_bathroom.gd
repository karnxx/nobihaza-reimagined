extends Node2D 

const HORROR1 = preload("res://assets/music/dark-horror-ambience-for-mystical-scenes-179447.mp3")
var current_music = [HORROR1]

func _ready() -> void: 
	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""


func start_cutscene(named: String):
	InventoryManager.active_cutscene = named
	Dialogic.start(named)
	InventoryManager.start_cutscene()

func cutsceneend():
	end_cutscene()

func end_cutscene():
	if InventoryManager.active_cutscene != "":
		InventoryManager.mark_cutscene_done(InventoryManager.active_cutscene)
	InventoryManager.active_cutscene = ""
	InventoryManager.end_cutscene()
