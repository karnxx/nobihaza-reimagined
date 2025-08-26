extends StaticBody2D

@export var sceneeee: String
@export var spawnwn:String

func interact():
	print("Ad")
	GameManager.change_scene(sceneeee, spawnwn)
