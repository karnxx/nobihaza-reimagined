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
@export var walk_speed : float
@export var rang :int = 500
@onready var icon: Sprite2D = $Sprite2D
var picked = false
func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.texture = textur
	interact()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon.texture = textur

func interact():
	var item = {
		"type": "gun",
		"name": nam,
		"qty":qty,
		"desc": desc,
		"texture": textur,
		"effect": effect
	}
	
	var gun = {
		"name":nam,
		"script": scene_path,
		"ammo_type": ammo_type,
		"current_ammo": current_ammo,
		"max_ammo": max_ammo,
		"damage": damage,
		"fire_rate": fire_rate,
		"reload_time": reload_time,
		"walk_speed":walk_speed,
		"range": rang
	}
	if InventoryManager.plr != null and picked == false:
		InventoryManager.add_item(item)
		InventoryManager.add_gun(gun)
		picked = true
		self.queue_free()
