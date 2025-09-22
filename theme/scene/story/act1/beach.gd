extends Node2D 
const s1 = preload("res://assets/music/footstep/ocean-waves-376898.mp3")
const s2 = preload("res://assets/music/footstep/ocean-waves-376898.mp3")
var current_music = [s1, s2]
var musse
func _ready() -> void: 
	musse = current_music.pick_random()
	if GameManager.next_spawn != "": 
		var spawn = get_node_or_null("spawns/" + GameManager.next_spawn) 
		if spawn and has_node("plr"): 
			$plr.global_position = spawn.global_position 
		GameManager.next_spawn = ""
	$AudioStreamPlayer2D.stream = musse 
	$AudioStreamPlayer2D2.stream = musse 
	$AudioStreamPlayer2D3.stream = musse 
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D2.play()
	$AudioStreamPlayer2D3.play()
	await get_tree().process_frame
	if not InventoryManager.is_cutscene_done("nobita_beach"):
		start_cutscene("nobita_beach")
	if not Dialogic.timeline_ended.is_connected(cutsceneend):
		Dialogic.timeline_ended.connect(cutsceneend)
	


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
