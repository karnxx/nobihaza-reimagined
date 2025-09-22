extends StaticBody2D

var state_1 = true
var state_2 = false

@export var dialogsd : String
@export var sprite1 : Texture
@export var sprite2 : Texture
@export var taken_item : String
@export var puzzle_id : String

@onready var sprite = $sprite
@onready var key_ui = $"../plr/camera/invslee"

func _ready() -> void:
	if puzzle_id != "" and puzzle_id in InventoryManager.puzzles_done:
		state_1 = false
		state_2 = true
	Dialogic.timeline_ended.connect(dialog_end)
func _process(_delta: float) -> void:
	if state_1 and not state_2:
		sprite.texture = sprite1
	else:
		sprite.texture = sprite2
		if get_node_or_null('item') != null:
			get_node('item').can_collect = true
func interact():
	if state_1 and not state_2:
		InventoryManager.freeze = true
		var has_key := false
		for item in InventoryManager.inv:
			if item != null and item["type"] == "key" and item["name"] == taken_item:
				has_key = true
				break
		if has_key:
			key_ui.open_for(self)
		else:
			if dialogsd != "":
				Dialogic.start(dialogsd)
	else:
		if get_node_or_null('item') != null:
			get_node('item').interact()

				
func try_item(item: Dictionary) -> bool:
	if state_1 and not state_2:
		if item["name"] == taken_item:
			InventoryManager.remove_item(taken_item)
			solve()
			InventoryManager.freeze = false
			return true
		else:
			return false
	return false

func solve():
	state_1 = false
	state_2 = true
	if puzzle_id != "" and puzzle_id not in InventoryManager.puzzles_done:
		InventoryManager.puzzles_done.append(puzzle_id)

func dialog_end() -> void:
	InventoryManager.freeze = false
