@tool
extends StaticBody2D

@export var nam : String
@export var desc : String
@export var textur : Texture
@export var effect : String
@export var qty : int
@export var scene_path : Script
@export var ammo_type : String
@export var current_ammo : int = 0
@export var max_ammo : int = 30
@export var damage : int = 25
@export var fire_rate : float = 0.1
@export var reload_time : float = 1.5
@export var walk_speed : float
@export var rang : int = 500
@export var texthing : Texture
@export var miss_chance : float
@export var crit_chance : float
@export var through_thing : int
@export var item_id : String = ""

@onready var icon: Sprite2D = $Sprite2D


func _ready() -> void:
	if not Engine.is_editor_hint():
		icon.texture = textur
		if item_id != "" and item_id in InventoryManager.items_collected:
			queue_free()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		icon.texture = textur


func interact():
	var item = {
		"type": "gun",
		"name": nam,
		"qty": qty,
		"desc": desc,
		"texture": textur,
		"effect": effect
	}
	
	var gun = {
		"name": nam,
		"desc": desc,
		"script": scene_path,
		"ammo_type": ammo_type,
		"current_ammo": current_ammo,
		"max_ammo": max_ammo,
		"damage": damage,
		"fire_rate": fire_rate,
		"reload_time": reload_time,
		"walk_speed": walk_speed,
		"range": rang,
		"texture": texthing,
		"miss_chance": miss_chance,
		"crit_chance": crit_chance,
		"through": through_thing
	}

	if InventoryManager.plr != null:
		if InventoryManager.add_item(item):
			InventoryManager.add_gun(gun, InventoryManager.gun_inv)
			if item_id != "" and item_id not in InventoryManager.items_collected:
				InventoryManager.items_collected.append(item_id)
			$CollisionShape2D.disabled = true
			visible = false 
			$AudioStreamPlayer2D.play()
			await $AudioStreamPlayer2D.finished
			queue_free()
