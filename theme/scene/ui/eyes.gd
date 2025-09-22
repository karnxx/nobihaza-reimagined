extends CanvasLayer


func _on_visibility_changed() -> void:
	var twen =create_tween()
	if visible:
		twen.tween_property($ColorRect, "modulate:a", 0.0, 0.5)
	else:
		twen.tween_property($ColorRect, "modulate:a", 1.0, 0.5)
