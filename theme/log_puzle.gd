extends StaticBody2D

var state = 1

func _process(delta: float) -> void:
	var sprite = $sprite
	if state == 1:
		sprite.texture = preload("res://assets/items/puzles/logstate1.png")
	elif state == 2:
		sprite.texture = preload("res://assets/items/puzles/logstate2.png")
	elif state == 3:
		sprite.texture = preload("res://assets/items/puzles/logstate3.png")
