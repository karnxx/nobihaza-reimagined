extends StaticBody2D
var state = 1
@export var dialogg := ""
@export var state1 : Texture
@export var state2 : Texture
@export var health := 30
@export var sound : AudioStream
@export var sound2 : AudioStream
@export var puzleid : String
func _ready() -> void:
	$AudioStreamPlayer2D.stream = sound
	if puzleid != "" and puzleid in InventoryManager.puzzles_done:
		state = 2
func _process(_delta: float) -> void:
	var pilesprite = get_node_or_null('sprite')
	if state == 1:
		pilesprite.texture = state1
		$CollisionShape2D.disabled = false
	elif state == 2:
		pilesprite.texture = state2

func interact():
	if state == 1:
		Dialogic.start(dialogg)
	elif state == 2:
		if get_node_or_null('item') != null:
			get_node_or_null('item').can_collect = true
			get_node_or_null('item').interact

func get_dmged(dmg):
	health -= dmg
	if health <= 0:
		$AudioStreamPlayer2D.stream = sound2
		state = 2
		if puzleid != "" and puzleid not in InventoryManager.puzzles_done:
			InventoryManager.puzzles_done.append(puzleid)
	$AudioStreamPlayer2D.play()
