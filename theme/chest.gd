extends StaticBody2D

@export var puzleid: String
var state := 1
var item: Node = null

func _ready() -> void:
	item = get_node_or_null("item")
	if puzleid != "" and puzleid in InventoryManager.puzzles_done:
		state = 2
	spriteeeead()

func spriteeeead() -> void:
	if state == 1:
		$Sprite2D.texture = preload("res://assets/tileset/chest_closed.png")
	else:
		$Sprite2D.texture = preload("res://assets/tileset/chest_opened.png")

func interact() -> void:
	if state == 1:
		state = 2
		spriteeeead()
		if item:
			item.can_collect = true
		$AudioStreamPlayer.play()
	else:
		if item:
			item.interact()
			item = null
