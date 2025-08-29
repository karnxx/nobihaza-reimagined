extends StaticBody2D

@export var sceneeee: String
@export var spawnwn:String


func _on_area_2d_body_entered(body: Node2D) -> void:
	GameManager.change_scene(sceneeee, spawnwn)
