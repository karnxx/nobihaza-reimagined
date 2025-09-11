extends ColorRect


func _on_tree_entered() -> void:
	var twen = create_tween()
	twen.tween_property(self, "modulate:a", 1.0, 0.5)



func _on_tree_exiting() -> void:
	var twen = create_tween()
	twen.tween_property(self, "modulate:a", 0.0, 0.5)
