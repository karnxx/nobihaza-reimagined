extends CanvasLayer

func _input(event: InputEvent) -> void:
	await get_tree().create_timer(3).timeout

	var twen = create_tween()
	twen.tween_property($Label, "modulate:a", 0.0, 5.0)
	twen.tween_callback(queue_free)
