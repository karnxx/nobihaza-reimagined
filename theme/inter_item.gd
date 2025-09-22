@tool
extends Node2D

@export var dialog : String
@export var type : String
@export var nam : String
@export var desc : String
@export var textur : Texture
@export var effect : String
@export var scene_path : String
@export var qty : int
@export var sound : AudioStream
@export var item_id : String = ""
@export var take_item : String
@export var can_collect : bool
@export var quest := ""

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
	$CollisionShape2D2.disabled = not can_collect

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
		if take_item != "":
			for i in InventoryManager.inv:
				if i != null and i["name"] == take_item:
					InventoryManager.remove_item(take_item)
					break
		if InventoryManager.add_item(item):
			if dialog != "":
				Dialogic.start(dialog)
			InventoryManager.mark_item_collected(item_id)
			$CollisionShape2D2.disabled = true
			visible = false
			$AudioStreamPlayer2D.play()
			if quest != "":
				GameManager.current_quest = quest
			if $AudioStreamPlayer2D.stream != null:
				await $AudioStreamPlayer2D.finished
			queue_free()
