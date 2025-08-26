@tool
extends StaticBody2D

@export var nam :String
@export var desc :String
@export var textur :Texture
@export var effect :String
@export var qty:int
@export var scene_path :Script
@export var ammo_type :String
@export var current_ammo :int = 0
@export var max_ammo :int = 30
@export var damage :int = 25
@export var fire_rate :float = 0.1
@export var reload_time :float = 1.5
@export var range :int = 500
@onready var icon: Sprite2D = $Sprite2D

func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.texture = textur
	interact()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		icon.texture = textur

func interact():
	var item = {
		"type": "gun",
		"name": nam,
		"qty":qty,
		"desc": desc,
		"texture": textur,
		"script": scene_path,
		"effect": effect
	}
	
	var gun = {
		"name":nam,
		"ammo_type": ammo_type,
		"current_ammo": current_ammo,
		"max_ammo": max_ammo,
		"damage": damage,
		"fire_rate": fire_rate,
		"reload_time": reload_time,
		"range": range
	}

	if InventoryManager.plr != null:
		InventoryManager.add_item(item)
		InventoryManager.add_gun(gun)
		self.queue_free()
