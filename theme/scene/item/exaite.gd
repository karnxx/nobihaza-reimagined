@tool
extends Node2D

@export var type : String
@export var nam : String
@export var desc : String
@export var textur : Texture
@export var effect : String
@export var scene_path : String
@export var qty : int
@export var sound : AudioStream
@export var item_id : String = ""  
@export var can_collect : bool
@onready var icon: Sprite2D = $Sprite2D

func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.texture = textur
		$AudioStreamPlayer2D.stream = sound
		if InventoryManager.is_item_collected(item_id):
			queue_free()

			

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon.texture = textur
	if can_collect == false:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false
func interact():
	var item = {
		"qty": qty,
		"type": type,
		"name": nam,
		"desc": desc,
		"texture": textur,
		"effect": effect,
		"scenepath": scene_path,
	}

	if InventoryManager.plr and can_collect:
		if InventoryManager.add_item(item):
			InventoryManager.mark_item_collected(item_id)
			$CollisionShape2D.disabled = true
			visible = false
			$AudioStreamPlayer2D.play()
			await $AudioStreamPlayer2D.finished
			queue_free()
