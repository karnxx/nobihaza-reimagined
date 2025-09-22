extends AnimatedSprite2D
var asd
func _process(_delta: float) -> void:
	if get_parent().get_node_or_null('item') != null:
		asd = get_parent().get_node_or_null('item')
		if asd.can_collect == true:
			self.visible = true
		else:
			self.visible = false
	else:
		self.visible = false
