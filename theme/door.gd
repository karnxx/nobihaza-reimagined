extends StaticBody2D

@export var sceneeee: String
@export var spawnwn: String
@export var cutscenename: String
@export var item_name: String
@export var can_collect : bool = true
func interact():
	var has_item := false
	print(can_collect, has_item)
	for i in InventoryManager.inv:
		if i != null and item_name != "none":
			if i['name'] == item_name:
				has_item = true
				break
	if item_name == "none":
		has_item = true
	if has_item and can_collect:
		GameManager.change_scene(sceneeee, spawnwn)
	else:
		if cutscenename != "":
			Dialogic.start(cutscenename)
