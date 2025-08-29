extends StaticBody2D

@export var sceneeee: String
@export var spawnwn: String
@export var key_name: String

func interact():
	for i in InventoryManager.inv:
		if i["name"] == key_name:
			GameManager.change_scene(sceneeee, spawnwn)
