@tool
extends Node2D

@export var type :String
@export var nam :String
@export var desc :String
@export var textur : Texture
@export var effect :String
@export var scene_path :String
@export var qty : int
@onready var icon: Sprite2D = $Sprite2D
@export var sound : AudioStream
var can_int := true
func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.texture = textur
	$AudioStreamPlayer2D.stream = sound

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon.texture = textur

func interact():
	var item = {
		"qty": qty,
		"type": type,
		"name": nam,
		"desc":desc,
		"texture": textur,
		"effect": effect,
		"scenepath": scene_path,
	}
	if InventoryManager.plr and can_int:
		InventoryManager.add_item(item)
		$CollisionShape2D2.disabled = true
		visible = false
		can_int = false
		$AudioStreamPlayer2D.play()
		await $AudioStreamPlayer2D.finished
		self.queue_free()
